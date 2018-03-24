defmodule Voyager.Policy do
  @moduledoc """
  Behaviour for contexts with authorization
  """
  @type auth_result :: :ok | {:error, reason :: any}
  @callback authorize(action :: atom, user :: any, params :: %{atom => any} | any) ::
              auth_result
end
