defmodule SimulationCities.CityTest do
  use ExUnit.Case
  doctest SimulationCities.City

  alias SimulationCities.City

  describe "new/2 基本的な都市作成" do
    test "有効な座標で都市を作成できる" do
      assert {:ok, city} = City.new(100, 200)
      assert city.x == 100
      assert city.y == 200
      assert city.population == 0
      assert city.agricultural_level == 0
      assert city.industrial_level == 0
      assert city.commercial_level == 0
      assert city.production_items == []
      assert city.specialty_products == []
    end

    test "最小値（1, 1）で都市を作成できる" do
      assert {:ok, city} = City.new(1, 1)
      assert city.x == 1
      assert city.y == 1
    end

    test "最大値（999, 999）で都市を作成できる" do
      assert {:ok, city} = City.new(999, 999)
      assert city.x == 999
      assert city.y == 999
    end
  end

  describe "new/3 オプションを指定した都市作成" do
    test "人口を指定して都市を作成できる" do
      assert {:ok, city} = City.new(100, 100, population: 5000)
      assert city.population == 5000
    end

    test "農業レベルを指定して都市を作成できる" do
      assert {:ok, city} = City.new(100, 100, agricultural_level: 3)
      assert city.agricultural_level == 3
    end

    test "工業レベルを指定して都市を作成できる" do
      assert {:ok, city} = City.new(100, 100, industrial_level: 5)
      assert city.industrial_level == 5
    end

    test "商業レベルを指定して都市を作成できる" do
      assert {:ok, city} = City.new(100, 100, commercial_level: 2)
      assert city.commercial_level == 2
    end

    test "生産品目を指定して都市を作成できる" do
      production_items = ["米", "小麦"]
      assert {:ok, city} = City.new(100, 100, production_items: production_items)
      assert city.production_items == production_items
    end

    test "特産品を指定して都市を作成できる" do
      specialty_products = ["陶器", "絹"]
      assert {:ok, city} = City.new(100, 100, specialty_products: specialty_products)
      assert city.specialty_products == specialty_products
    end

    test "全ての属性を指定して都市を作成できる" do
      opts = [
        population: 10000,
        agricultural_level: 4,
        industrial_level: 6,
        commercial_level: 5,
        production_items: ["米", "野菜", "果物"],
        specialty_products: ["ワイン", "チーズ"]
      ]

      assert {:ok, city} = City.new(500, 500, opts)
      assert city.x == 500
      assert city.y == 500
      assert city.population == 10000
      assert city.agricultural_level == 4
      assert city.industrial_level == 6
      assert city.commercial_level == 5
      assert city.production_items == ["米", "野菜", "果物"]
      assert city.specialty_products == ["ワイン", "チーズ"]
    end
  end

  describe "new/2 座標の検証" do
    test "x座標が0の場合はエラー" do
      assert {:error, message} = City.new(0, 100)
      assert message == "x coordinate must be between 1 and 999"
    end

    test "x座標が負の場合はエラー" do
      assert {:error, message} = City.new(-1, 100)
      assert message == "x coordinate must be between 1 and 999"
    end

    test "x座標が1000の場合はエラー" do
      assert {:error, message} = City.new(1000, 100)
      assert message == "x coordinate must be between 1 and 999"
    end

    test "y座標が0の場合はエラー" do
      assert {:error, message} = City.new(100, 0)
      assert message == "y coordinate must be between 1 and 999"
    end

    test "y座標が負の場合はエラー" do
      assert {:error, message} = City.new(100, -1)
      assert message == "y coordinate must be between 1 and 999"
    end

    test "y座標が1000の場合はエラー" do
      assert {:error, message} = City.new(100, 1000)
      assert message == "y coordinate must be between 1 and 999"
    end

    test "x座標とy座標の両方が範囲外の場合はx座標のエラーが返る" do
      assert {:error, message} = City.new(0, 0)
      assert message == "x coordinate must be between 1 and 999"
    end
  end

  describe "validate_coordinate/2" do
    test "有効なx座標" do
      assert City.validate_coordinate(1, :x) == :ok
      assert City.validate_coordinate(500, :x) == :ok
      assert City.validate_coordinate(999, :x) == :ok
    end

    test "有効なy座標" do
      assert City.validate_coordinate(1, :y) == :ok
      assert City.validate_coordinate(500, :y) == :ok
      assert City.validate_coordinate(999, :y) == :ok
    end

    test "無効なx座標" do
      assert {:error, _} = City.validate_coordinate(0, :x)
      assert {:error, _} = City.validate_coordinate(1000, :x)
    end

    test "無効なy座標" do
      assert {:error, _} = City.validate_coordinate(0, :y)
      assert {:error, _} = City.validate_coordinate(1000, :y)
    end
  end
end
