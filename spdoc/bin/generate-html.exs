#!/usr/bin/env elixir


defmodule WalkDirectory do
  def recursive(visit, dir \\ ".", tasks \\ []) do
    new_tasks = Enum.flat_map(File.ls!(dir), fn file ->
      fname = "#{dir}/#{file}"
      #IO.puts fname
      if File.dir?(fname) do
        recursive(visit, fname)
      else
        [visit.(self(), fname)]
      end
    end)
    tasks ++ new_tasks
  end
end


# https://hexdocs.pm/elixir/System.html
#
defmodule Generator do
  def main(args) do
    show_banner(args)
    tasks = WalkDirectory.recursive(&Generator.visit_file/2, ".")
    Enum.each(tasks, fn task ->
      receive do
        {:done, _ref} ->
          #IO.puts "Task finished"
          :ok
      end
    end)
    IO.puts "Done."
  end

  defp show_banner(args) do
    IO.puts "Generating SPDoc html files"
    IO.puts "Arguments: #{Enum.join(args, " ")}"
    IO.puts "Who am I?: #{elem(System.cmd("whoami",[]),0)}"
    IO.puts "Elixir version: #{System.version}"
    IO.puts "Pandoc path:" <> System.find_executable("pandoc")
  end

  def visit_file(fname) do
    IO.puts "Visiting #{fname}"
    fext = String.downcase(Path.extname(fname))
    format = case fext do
      ".md" ->
        :md_format
      _ ->
        :unknown_format
    end
    category = Enum.at(Path.split(fname), -2)
    unless format == :unknown_format do
      IO.puts "file=#{fname}, category=#{category}, ext=#{fext}"
      generate_doc_for(fname, category, fext)
    end
  end

  def visit_file(parent_pid, fname) do
    ref = make_ref()
    spawn_link(fn ->
        visit_file(fname)
        send(parent_pid, {:done, ref})
      end
    )
    ref
  end

  defp generate_doc_for(fname, category, fext) do
    case category do
      "issues" ->
        generate_issue(fname, fext)
      _ ->
        IO.puts "Error: unknown category '#{category}'"
    end
  end

  defp generate_issue(fname, fext) do
    pandoc_args = ["-f", "markdown", "-t", "html", "-s", "#{fname}"]
    IO.puts "calling pandoc #{Enum.join(pandoc_args, " ")}"
    {msg, result} = System.cmd("pandoc", pandoc_args)
    #{msg, result} = System.cmd("ls", [])
    IO.puts "pandoc result:#{result} output=#{msg}"
  end
end

Generator.main(System.argv)

