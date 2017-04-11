defmodule Flatfoot.Factory do
  use ExMachina.Ecto, repo: Flatfoot.Repo

  def user_factory do
    pw = Faker.Code.isbn

    %Flatfoot.Clients.User{
      username: Faker.Internet.user_name,
      email: Faker.Internet.free_email,
      password_hash: Comeonin.Bcrypt.hashpwsalt(pw)
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

  def settings_factory do
    %Flatfoot.Clients.Settings{
      global_threshold: Enum.random(0..100),
      user: build(:user)
    }
  end

  def blackout_option_factory do
    %Flatfoot.Clients.BlackoutOption{
      start: random_ecto_time(),
      stop: random_ecto_time(),
      threshold: Enum.random(0..100),
      exclude: "[#{Faker.Address.state_abbr}, #{Faker.Address.state_abbr}]",
      settings: build(:settings)
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

  def target_factory do
    %Flatfoot.Spade.Target{
      name: Faker.Name.name,
      relationship: Faker.Team.creature,
      active: [true, false] |> Enum.random,
      user: build(:user)
    }
  end

  def target_account_factory do
    %Flatfoot.Spade.TargetAccount{
      handle: Faker.Internet.user_name,
      target: build(:target),
      backend: build(:backend)
    }
  end

  #####################
  # Private Functions #
  #####################

  defp random_ecto_time, do: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1)
end
