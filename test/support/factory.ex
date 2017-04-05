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
end
