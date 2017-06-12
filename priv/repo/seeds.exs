alias Flatfoot.{Clients, Spade, Archer, Repo, Clients.NotificationRecord,
                Clients.BlackoutOption, Spade.Ward, Spade.WardAccount,
                SpadeInspector, SpadeInspector.WardResult, Archer.Backend}

(1..10) |> Enum.each( fn (_) ->
  Clients.create_user(%{
    username: Faker.Internet.user_name,
    email: Faker.Internet.free_email,
    password: Faker.Code.isbn
  }) end
)

Clients.create_user(%{
  username: "dlively",
  email: "dlively@resurgens.io",
  password: "password"
})

users = Clients.list_users

users |> Enum.each(
  fn (user) ->
    Clients.login(%{
      token: SecureRandom.urlsafe_base64(),
      user_id: user.id
    })

    (1..5) |> Enum.each( fn(_) ->
      Spade.create_ward(%{
        name: Faker.Name.name,
        relationship: Faker.Team.creature,
        active: [true, false] |> Enum.random,
        user_id: user.id
      }) end
  ) end
)

wards = Ward |> Repo.all

Archer.create_backend(%{
  name: "Twitter",
  name_snake: "twitter",
  url: "https://www.twitter.com/",
  module: "Elixir.Flatfoot.Archer.Backend.Twitter"
})

backend = Backend |> Repo.all |> List.first

wards |> Enum.each(
  fn (ward) ->
    Spade.create_ward_account(%{
      handle: "@#{Faker.Internet.user_name}",
      ward_id: ward.id,
      backend_id: backend.id
    })
  end
)

ward_accounts = WardAccount |> Repo.all

(1..1000) |> Enum.each(
  fn (_) ->
    SpadeInspector.create_ward_result(%{
      rating: Enum.random(0..100),
      from: "@#{Faker.Internet.user_name}",
      from_id: Enum.random(1000..9999) |> to_string,
      msg_id: Enum.random(1000..1999) |> to_string,
      msg_text: Faker.Lorem.Shakespeare.hamlet,
      ward_account_id: Enum.random(ward_accounts) |> Map.get(:id),
      backend_id: backend.id,
      timestamp: Ecto.DateTime.cast(%{year: 2017, month: Enum.random(1..3), day: Enum.random(1..15), hour: Enum.random(0..23), minute: Enum.random([0, 15, 30, 45]), second: 0}) |> elem(1)
    })
  end
)

ward_results = WardResult |> Repo.all

(1..75) |> Enum.each( fn(_) ->
  Clients.create_notification_record(%{
    nickname: Faker.Name.name,
    email: Faker.Internet.free_email,
    role: Faker.Company.buzzword,
    threshold: Enum.random(0..100),
    user_id: Enum.random(users) |> Map.get(:id)
  }) end
)

records = NotificationRecord |> Repo.all

(1..75) |> Enum.each( fn(_) ->
  Clients.create_blackout_option(%{
    start: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1),
    stop: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1),
    threshold: Enum.random(0..100),
    exclude: "[#{Faker.Address.state_abbr}, #{Faker.Address.state_abbr}]",
    user_id: Enum.random(users) |> Map.get(:id)
  })
end )

blackout_options = BlackoutOption |> Repo.all

IO.inspect "Seed complete"
IO.inspect "#{users |> length} users created"
IO.inspect "#{blackout_options |> length} blackout options created"
IO.inspect "#{records |> length} notification records created"
IO.inspect "#{wards |> length} wards created"
IO.inspect "#{ward_accounts |> length} ward accounts created"
IO.inspect "#{ward_results |> length} ward results created"
IO.inspect "1 backend created"
