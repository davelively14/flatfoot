alias Flatfoot.Clients

(1..10) |> Enum.each( fn (_) ->
  Clients.create_user(%{
    username: Faker.Internet.user_name,
    email: Faker.Internet.free_email,
    password: Faker.Code.isbn
  }) end
)
