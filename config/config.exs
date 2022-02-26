import Config

#Import environment specific config. Thias must remain at the bottom
#of this file so it overrides the configuration defined above
import_config "#{config_env()}.exs"
