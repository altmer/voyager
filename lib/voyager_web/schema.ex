defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  # create_table "trips", force: :cascade do |t|
  #   t.string   "name"
  #   t.text     "short_description"
  #   t.date     "start_date"
  #   t.date     "end_date"
  #   t.boolean  "archived",               default: false
  #   t.text     "comment"
  #   t.integer  "budget_for",             default: 1
  #   t.boolean  "private",                default: false
  #   t.string   "image_uid"
  #   t.string   "status_code",            default: "0_draft"
  #   t.integer  "author_user_id"
  #   t.datetime "updated_at"
  #   t.datetime "created_at"
  #   t.string   "currency"
  #   t.boolean  "dates_unknown",          default: false
  #   t.integer  "planned_days_count"
  #   t.string   "countries_search_index"
  #   t.index ["author_user_id"], name: "index_trips_on_author_user_id", using: :btree
  # end

  import_types(VoyagerWeb.Schema.UsersTypes)
  import_types(VoyagerWeb.Schema.SessionsTypes)
  import_types(VoyagerWeb.Schema.PasswordsTypes)

  query do
    import_fields(:users_queries)
    import_fields(:sessions_queries)
  end

  mutation do
    import_fields(:users_mutations)
    import_fields(:sessions_mutations)
    import_fields(:passwords_mutations)
  end
end
