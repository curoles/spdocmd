#!/usr/bin/env elixir


defmodule Walk_directory do
  def recursive(visit, dir \\ ".") do
    Enum.each(File.ls!(dir), fn file ->
      fname = "#{dir}/#{file}"
      #IO.puts fname
      if File.dir?(fname) do
        recursive(visit, fname)
      else
        visit.(fname)
      end
    end)
  end
end


# https://hexdocs.pm/elixir/System.html
#
defmodule Generator do
  def main(args) do
    show_banner(args)
    Walk_directory.recursive(&Generator.visit_file/1, ".")
  end

  defp show_banner(args) do
    IO.puts "Generating SPDoc html files"
    IO.puts "Arguments: #{Enum.join(args, " ")}"
    IO.puts "Elixir version: #{System.version}"
    IO.puts "Pandoc path:" <> System.find_executable("pandoc")
  end

  def visit_file(fname) do
    IO.puts "Visiting #{fname}"
  end
end

Generator.main(System.argv)

