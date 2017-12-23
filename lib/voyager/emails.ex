defmodule Voyager.Emails.Mailer do
  @moduledoc """
    Main application mailer
  """
  use Bamboo.Mailer, otp_app: :voyager
end

defmodule Voyager.Emails do
  @moduledoc """
    All the different emails that are sent by app
  """
  use Bamboo.Phoenix, view: VoyagerWeb.EmailView

  import VoyagerWeb.Gettext

  alias Voyager.Emails.Mailer

  def reset_password_email(email_address, name, reset_link, nil),
    do: reset_password_email(email_address, name, reset_link, "en")

  def reset_password_email(email_address, name, reset_link, locale) do
    Gettext.put_locale(Voyager.Web.Gettext, locale)

    base_email()
    |> to({name, email_address})
    |> subject(gettext("Password reset"))
    |> render(
      "password_reset.html",
      reset_link: reset_link,
      name: name
    )
  end

  defp base_email do
    new_email()
    |> from(Application.get_env(:voyager, Mailer)[:from])
    |> put_html_layout({VoyagerWeb.LayoutView, "email.html"})
  end
end
