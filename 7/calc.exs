defmodule Calc do
  @max_directory_size 100000

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
    |> get_directories_size()
    |> get_total_free_up_space()
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
  defp build_tree(["$ cd .." | next], state), do:
    build_tree(next, up_one_directory(state))
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

    {file_size, _} = Integer.parse(file_size)

    add_file(state, file_name, file_size)
  end

  defp up_one_directory(directory = %{directories: []}) do
    directory
  end

  defp up_one_directory(directory = %{directories: dirs}) do
    if Enum.any?(dirs, &(&1.current)) do
      %TreeDirectory{directory | current: true}
    else
      new_directories = 
        dirs
        |> Enum.map(&up_one_directory/1)
      
      %TreeDirectory{directory | directories: new_directories}
    end
  end
  
  defp change_directory(directory = %TreeDirectory{
      current: current, 
      name: dir_name, 
      directories: directories
  }, name, parent_current \\ true) do
    new_directories =
      directories
      |> Enum.map(&change_directory(&1, name, current))
    
    current = parent_current && dir_name == name

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

  defp get_directories_size(directory, directories \\ [])
  defp get_directories_size(%{directories: [], files: files}, directories) do
    size = get_elements_size(files)

    [size | directories]
  end

  defp get_directories_size(%{directories: sub_directories, files: files}, directories) do
    size = get_elements_size(files)

    computed_sub_directories = 
      sub_directories 
      # recomputation later, this passes [] because it's considering itself as the root
      |> Enum.flat_map(&get_directories_size(&1))
      
    additional_size = 
      computed_sub_directories
      |> Enum.sum()

    new_directories =
      sub_directories
      |> Enum.reduce(directories, &get_directories_size/2)

    [size + additional_size | new_directories]
  end

  defp get_elements_size(elements) do
    elements
    |> Enum.map(&(&1.size))
    |> Enum.sum()
  end

  defp get_total_free_up_space(directories) do
    directories
    |> Enum.filter(&(&1 < @max_directory_size))
    |> Enum.sum()
  end
end
