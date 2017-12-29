defmodule VoyagerWeb.Resolvers do
  @moduledoc """
  Common functions for graphql resolvers
  """
  alias Ecto.Changeset

  alias Kronky.Payload
  alias Kronky.ValidationMessage
  alias Kronky.ChangesetParser

  def single_query_result(nil),
    do: {:error, :not_found}
  def single_query_result(result),
    do: {:ok, result}

  def mutation_result({:ok, result}),
    do: {:ok, Payload.success_payload(result)}
  def mutation_result({:error, %Ecto.Changeset{} = changeset}),
    do: {:ok, changeset |> extract_messages() |> Payload.error_payload()}

  def not_authorized(),
    do: {:error, "Not Authorized"}

  defp extract_messages(changeset) do
    changeset
    |> Changeset.traverse_errors(&construct_traversed_message/3)
    |> Enum.to_list
    |> Enum.flat_map(fn({_field, values}) -> values end)
  end

  defp construct_traversed_message(_changeset, field, {message, opts}) do
    construct_message(field, {message, opts})
  end

  defp construct_message(field, {message, opts}) do
    %ValidationMessage{
      code: ChangesetParser.to_code({message, opts}),
      field: field,
      key: field,
      template: translate_error({message, opts}),
      message: translate_error({message, opts}),
      options: Keyword.drop(opts, [:validation, :max, :is, :min, :code])
    }
  end

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(VoyagerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(VoyagerWeb.Gettext, "errors", msg, opts)
    end
  end
end
