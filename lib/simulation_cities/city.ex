defmodule SimulationCities.City do
  @moduledoc """
  都市を表すモジュール。

  都市は交易によって発展するシミュレーションの基本単位です。
  """

  @enforce_keys [:x, :y]
  defstruct [
    :x,
    :y,
    population: 0,
    agricultural_level: 0,
    industrial_level: 0,
    commercial_level: 0,
    production_items: [],
    specialty_products: []
  ]

  @type t :: %__MODULE__{
          x: 1..999,
          y: 1..999,
          population: non_neg_integer(),
          agricultural_level: non_neg_integer(),
          industrial_level: non_neg_integer(),
          commercial_level: non_neg_integer(),
          production_items: list(String.t()),
          specialty_products: list(String.t())
        }

  @doc """
  新しい都市を作成します。

  座標はx、yともに1から999までの範囲で指定可能です。

  ## パラメータ

    * `x` - x座標 (1..999)
    * `y` - y座標 (1..999)
    * `opts` - オプションのキーワードリスト
      * `:population` - 人口（デフォルト: 0）
      * `:agricultural_level` - 農業レベル（デフォルト: 0）
      * `:industrial_level` - 工業レベル（デフォルト: 0）
      * `:commercial_level` - 商業レベル（デフォルト: 0）
      * `:production_items` - 生産品目（デフォルト: []）
      * `:specialty_products` - 特産品（デフォルト: []）

  ## 例

      iex> {:ok, city} = SimulationCities.City.new(100, 200)
      iex> city.x
      100
      iex> city.y
      200
      iex> city.population
      0

      iex> {:ok, city} = SimulationCities.City.new(1, 1, population: 1000)
      iex> city.population
      1000

      iex> SimulationCities.City.new(0, 100)
      {:error, "x coordinate must be between 1 and 999"}

      iex> SimulationCities.City.new(100, 1000)
      {:error, "y coordinate must be between 1 and 999"}

  """
  @spec new(integer(), integer(), keyword()) :: {:ok, t()} | {:error, String.t()}
  def new(x, y, opts \\ []) do
    with :ok <- validate_coordinate(x, :x),
         :ok <- validate_coordinate(y, :y) do
      city = %__MODULE__{
        x: x,
        y: y,
        population: Keyword.get(opts, :population, 0),
        agricultural_level: Keyword.get(opts, :agricultural_level, 0),
        industrial_level: Keyword.get(opts, :industrial_level, 0),
        commercial_level: Keyword.get(opts, :commercial_level, 0),
        production_items: Keyword.get(opts, :production_items, []),
        specialty_products: Keyword.get(opts, :specialty_products, [])
      }

      {:ok, city}
    end
  end

  @doc """
  座標が有効な範囲内かを検証します。

  ## 例

      iex> SimulationCities.City.validate_coordinate(100, :x)
      :ok

      iex> SimulationCities.City.validate_coordinate(0, :x)
      {:error, "x coordinate must be between 1 and 999"}

      iex> SimulationCities.City.validate_coordinate(1000, :y)
      {:error, "y coordinate must be between 1 and 999"}

  """
  @spec validate_coordinate(integer(), :x | :y) :: :ok | {:error, String.t()}
  def validate_coordinate(value, _axis) when value >= 1 and value <= 999, do: :ok

  def validate_coordinate(_value, axis) do
    {:error, "#{axis} coordinate must be between 1 and 999"}
  end
end
