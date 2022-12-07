defmodule Calc do
  defmodule TreeDirectory do
    defstruct name: "",
              current: false,
              files: [],
              directories: []

    @type t() :: %__MODULE__{
      name: binary(),
      current: boolean(),
      files: list(TreeFile.t()),
      directories: list(TreeDirectory.t())
    }

    def new(name) do
      %TreeDirectory{
        name: name,
        current: false
      }
    end
  end

  defmodule TreeFile do
    defstruct name: "", 
              size: 0

    @type t() :: %__MODULE__{
      name: binary(),
      size: non_neg_integer()
    }

    def new(name, size) do
      %TreeFile{
        name: name,
        size: size
      }
    end
  end

  def compute(file_name \\ "input") do
    File.read!(file_name)
    |> get_lines()
    |> build_tree()
  end

  defp get_lines(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&filter_empty_lines/1)
  end

  defp filter_empty_lines(""), do: false
  defp filter_empty_lines(nil), do: false
  defp filter_empty_lines(_), do: true

  defp build_tree(input, state \\ %TreeDirectory{
    name: "/",
    current: true
  })
  defp build_tree([], state), do: state
  defp build_tree(["$ cd " <> directory_name | next], state), do: 
    build_tree(next, change_directory(state, directory_name))
  defp build_tree(["$ ls" | next], state), do: 
    build_tree(next, state)
  defp build_tree([item | next], state), do:
    build_tree(next, extract_item_info(item, state))
    
  defp extract_item_info("dir " <> directory_name, state) do
    add_directory(state, directory_name)
  end

  defp extract_item_info(file_info, state) do
    [file_size, file_name] = 
      file_info
      |> String.split(" ") 
      |> Enum.filter(&filter_empty_lines/1)

    add_file(state, file_name, file_size)
  end
  
  defp change_directory(directory = %TreeDirectory{name: dir_name, directories: directories}, name) do
    new_directories =
      directories
      |> Enum.map(&change_directory(&1, name))
    
    current = dir_name == name

    %TreeDirectory{directory | current: current, directories: new_directories}
  end

  defp add_directory(directory = %{current: true, directories: dirs}, dir_name) do
    case Enum.any?(dirs, fn %{name: dn} -> dn == dir_name end) do
      false -> 
        %{directory | directories: [TreeDirectory.new(dir_name) | dirs]}
      _ -> 
        directory
    end
  end
  
  defp add_directory(dir = %{directories: dirs}, dir_name) do
    new_dirs = 
      dirs
      |> Enum.map(&add_directory(&1, dir_name))

    %TreeDirectory{dir | directories: new_dirs}
  end

  defp add_file(directory = %{current: true, files: files}, file_name, file_size) do
    case files |> Enum.any?(fn %{name: fnam} -> fnam == file_name end) do
      false -> 
        %{directory | files: [TreeFile.new(file_name, file_size) | files]}
      _ -> 
        directory
    end
  end
  
  defp add_file(dir = %{directories: dirs}, file_name, file_size) do
    new_dirs = 
      dirs
      |> Enum.map(&add_file(&1, file_name, file_size))

    %TreeDirectory{dir | directories: new_dirs}
  end
end
