#!/usr/bin/env elixir


defmodule WalkDirectory do
  def recursive(visit, dest, dir \\ ".", tasks \\ []) do
    File.mkdir_p(dest)
    new_tasks = Enum.flat_map(File.ls!(dir), fn file ->
      fname = "#{dir}/#{file}"
      #IO.puts fname
      if File.dir?(fname) do
        recursive(visit, "#{dest}/#{file}", fname)
      else
        [visit.(self(), fname, dest)]
      end
    end)
    tasks ++ new_tasks
  end
end


defmodule Generator do

  def main(args) do
    args |> show_banner |> parse_args |> process
    IO.puts "Done."
  end

  defp show_banner(args) do
    IO.puts "Generate SPDoc html files"
    #IO.puts "Arguments: #{Enum.join(args, " ")}"
    #IO.puts "Who am I?: #{elem(System.cmd("whoami",[]),0)}"
    IO.puts "Elixir version: #{System.version}"
    #IO.puts "Pandoc path:" <> System.find_executable("pandoc")
    args
  end

  defp parse_args(args) do
    {switches, filelist, _} = OptionParser.parse(args,
      switches: [dest: :string]
    )
    {switches, filelist}
  end

  defp process({[],[]}) do
    IO.puts "No arguments given"
  end

  defp process({_,[]}) do
    IO.puts "No location of input directory given"
  end

  defp process({switches, filelist}) do
    [source | _] = filelist
    dest = switches[:dest]
    IO.puts "Source: '#{source}', destination: '#{dest}'"
    tasks = WalkDirectory.recursive(&Generator.visit_file/3, dest, source)
    Enum.each(tasks, fn _task ->
      receive do
        {:done, _ref} ->
          #IO.puts "Task finished"
          :ok
      end
    end)
  end

  def visit_file(fname, dest) do
    IO.puts "Visiting #{fname}"
    fext = String.downcase(Path.extname(fname))
    format = case fext do
      ".md" ->
        :md_format
      _ ->
        :unknown_format
    end
    category = Enum.drop(Path.split(fname), -1) |> Enum.reverse
    unless format == :unknown_format do
      IO.puts "file=#{fname}, category=#{Enum.join(category,"/")}, ext=#{fext}"
      generate_doc_for(fname, category, fext, dest)
    end
  end

  def visit_file(parent_pid, fname, dest) do
    ref = make_ref()
    spawn_link(fn ->
        visit_file(fname, dest)
        send(parent_pid, {:done, ref})
      end
    )
    ref
  end

  defp generate_doc_for(fname, category, fext, dest) do
    case category do
      ["issues" | _] ->
        generate_issue(fname, fext, dest)
      #["notes", user, "users", | _] ->
      _ ->
        IO.puts "Error: unknown category '#{Enum.join(category,"/")}'"
    end
  end

  defp generate_issue(fname, fext, dest) do
    dest_fname = String.replace(Path.basename(fname, fext),"#","N") <> ".html"
    dest_path = Path.join(dest, dest_fname)
    pandoc_args = ["-f", "markdown", "-t", "html", "-s", "-o", dest_path, fname]
    IO.puts "calling pandoc #{Enum.join(pandoc_args, " ")}"
    {msg, result} = System.cmd("pandoc", pandoc_args)
    IO.puts "pandoc result:#{result} output=#{msg}"
  end
end

Generator.main(System.argv)

