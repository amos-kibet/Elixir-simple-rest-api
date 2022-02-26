defmodule RestApi.Router do
  #Bring Plug.Router module into scope
  use Plug.Router

  #Attach the logger to log incoming requests
  plug(Plug.Logger)

  #Tell Plug to match incoming request with the defined endpoint
  plug(:match)

   # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route.(Using the Jayson parser)
  plug(Plug.Parsers,
  parsers: [:json],
  pass: ["application/json"],
  json_decoder: Jason
  )

  #Dispatch the conection to the matched handler
  plug(:dispatch)

  #Handler for GET request with "/" path
  get "/" do
    send_resp(conn, 200, "Hello and welcome to the back of the things, the backend!")
  end

  #Health check endpoint
  get "knockknock" do
    case Mongo.command(:mongo, ping: 1) do
      {:ok, res} -> send_resp(conn, 200, "Who's there?")
      {:error, res} -> send_resp(conn, 500, "Something went wrong")
    end
  end

  #Fallback handler when there is no match
  match _ do
    send_resp(conn, 404, "Not Found!")
  end

end
