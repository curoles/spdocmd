---
title:  'Random Notes about Elixir'
author: Igor Lesik
---

## Load modules into Elixir script
See Jose Valim answer [Load modules into Elixir script](https://stackoverflow.com/questions/29681310/elixir-script-load-all-modules-in-folder-recursivelly).


By Jose Valim.

1. A way to load everything in a directory is:

```
    dir
    |> Path.join("**/*.exs")
    |> Path.wildcard()
    |> Enum.map(&Code.require_file/1)
```

2. If you want to compile them, use:

```
    dir
    |> Path.join("**/*.ex")
    |> Path.wildcard()
    |> Kernel.ParallelCompiler.files_to_path("path/for/beam/files")
```

3. If you want to just compile another directory in the context of a project (with a mix.exs and what not), you can give any directory you want to Mix inside def project:

```
    elixirc_paths: ["lib", "my/other/path"]
```

