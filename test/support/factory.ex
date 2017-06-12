defmodule Flatfoot.Factory do
  use ExMachina.Ecto, repo: Flatfoot.Repo

  def user_factory do
    pw = Faker.Code.isbn

    %Flatfoot.Clients.User{
      username: Faker.Internet.user_name,
      email: Faker.Internet.free_email,
      password_hash: Comeonin.Bcrypt.hashpwsalt(pw),
      global_threshold: Enum.random(0..100)
    }
  end

  def session_factory do
    %Flatfoot.Clients.Session{
      token: SecureRandom.urlsafe_base64(),
      user: build(:user)
    }
  end

  def notification_record_factory do
    %Flatfoot.Clients.NotificationRecord{
      nickname: Faker.Name.name,
      email: Faker.Internet.free_email,
      role: Faker.Company.buzzword,
      threshold: Enum.random(0..100),
      user: build(:user)
    }
  end

  def blackout_option_factory do
    %Flatfoot.Clients.BlackoutOption{
      start: random_ecto_time(),
      stop: random_ecto_time(),
      threshold: Enum.random(0..100),
      exclude: "[#{Faker.Address.state_abbr}, #{Faker.Address.state_abbr}]",
      user: build(:user)
    }
  end

  def backend_factory do
    name = Faker.Name.name

    %Flatfoot.Archer.Backend{
      name: name,
      name_snake: name |> String.downcase |> String.replace(" ", "_"),
      url: Faker.Internet.url,
      module: "Flatfoot.Archer.#{name |> String.split(" ") |> Enum.map(&String.capitalize/1) |> List.to_string}"
    }
  end

  def ward_factory do
    %Flatfoot.Spade.Ward{
      name: Faker.Name.name,
      relationship: Faker.Team.creature,
      active: [true, false] |> Enum.random,
      user: build(:user)
    }
  end

  def ward_account_factory do
    %Flatfoot.Spade.WardAccount{
      handle: Faker.Internet.user_name,
      ward: build(:ward),
      backend: build(:backend)
    }
  end

  def watchlist_factory do
    %Flatfoot.Spade.Watchlist{
      name: Faker.Name.name,
      user: build(:user)
    }
  end

  def suspect_factory do
    %Flatfoot.Spade.Suspect{
      name: Faker.Name.name,
      category: Faker.Lorem.word,
      notes: Faker.Lorem.Shakespeare.hamlet,
      active: true,
      watchlist: build(:watchlist)
    }
  end

  def suspect_account_factory do
    %Flatfoot.Spade.SuspectAccount{
      handle: Faker.Internet.user_name,
      suspect: build(:suspect),
      backend: build(:backend)
    }
  end

  def ward_result_factory do
    %Flatfoot.Spade.WardResult{
      rating: Enum.random(0..100),
      from: Faker.Internet.user_name,
      from_id: Enum.random(1000..9999) |> to_string,
      msg_id: Enum.random(1000..1999) |> to_string,
      msg_text: Faker.Lorem.Shakespeare.hamlet,
      ward_account: build(:ward_account),
      backend: build(:backend),
      timestamp: random_ecto_datetime()
    }
  end

  #####################
  # Private Functions #
  #####################

  defp random_ecto_time, do: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1)
  defp random_ecto_datetime, do: Ecto.DateTime.cast(%{year: 2017, month: Enum.random(1..3), day: Enum.random(1..15), hour: Enum.random(0..23), minute: Enum.random([0, 15, 30, 45]), second: 0}) |> elem(1)
end
