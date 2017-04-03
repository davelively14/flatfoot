alias Flatfoot.{Clients, Repo, Clients.NotificationRecord}

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

users |> Enum.each( fn(user) ->
  Clients.login(%{
    token: SecureRandom.urlsafe_base64(),
    user_id: user.id
  }) end
)

(1..50) |> Enum.each( fn(_) ->
  Clients.create_notification_record(%{
    nickname: Faker.Name.name,
    email: Faker.Internet.free_email,
    role: Faker.Company.buzzword,
    threshold: Enum.random(0..100),
    user_id: Enum.random(users) |> Map.get(:id)
  }) end
)

records = NotificationRecord |> Repo.all

IO.inspect "Seed complete"
IO.inspect "#{users |> length} users created"
IO.inspect "#{records |> length} records created"
