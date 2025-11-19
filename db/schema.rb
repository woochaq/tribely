# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_19_195638) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body", size: :long
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "boards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kind", default: 0
    t.bigint "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_boards_on_project_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "story_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["story_id"], name: "index_comments_on_story_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.bigint "last_updated_by_id"
    t.bigint "project_id", null: false
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_documents_on_created_by_id"
    t.index ["last_updated_by_id"], name: "index_documents_on_last_updated_by_id"
    t.index ["project_id"], name: "index_documents_on_project_id"
  end

  create_table "email_subscriptions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_email_subscriptions_on_email", unique: true
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.bigint "organization_id", null: false
    t.bigint "recipient_id"
    t.integer "role", default: 1, null: false
    t.bigint "sender_id", null: false
    t.integer "status", default: 0
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["recipient_id"], name: "index_invitations_on_recipient_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "organization_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "organization_id", null: false
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "project_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.bigint "project_id", null: false
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["added_by_id"], name: "index_project_users_on_added_by_id"
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.string "prefix", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_projects_on_organization_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "stories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "done_at"
    t.bigint "last_updated_by_id"
    t.integer "number", null: false
    t.bigint "owner_id", null: false
    t.integer "position", null: false
    t.string "prefix_with_number"
    t.bigint "project_id", null: false
    t.string "slug"
    t.integer "status", default: 0, null: false
    t.integer "story_type", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["board_id"], name: "index_stories_on_board_id"
    t.index ["last_updated_by_id"], name: "index_stories_on_last_updated_by_id"
    t.index ["owner_id"], name: "index_stories_on_owner_id"
    t.index ["prefix_with_number"], name: "index_stories_on_prefix_with_number"
    t.index ["project_id", "slug"], name: "index_stories_on_project_id_and_slug", unique: true
    t.index ["project_id"], name: "index_stories_on_project_id"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.datetime "last_triggered_at"
    t.string "name"
    t.bigint "project_id", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.integer "webhook_type", default: 0, null: false
    t.index ["board_id"], name: "index_webhooks_on_board_id"
    t.index ["created_by_id"], name: "index_webhooks_on_created_by_id"
    t.index ["project_id"], name: "index_webhooks_on_project_id"
    t.index ["token"], name: "index_webhooks_on_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boards", "projects"
  add_foreign_key "comments", "stories"
  add_foreign_key "comments", "users"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "users", column: "created_by_id"
  add_foreign_key "documents", "users", column: "last_updated_by_id"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "users", column: "recipient_id"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "project_users", "users", column: "added_by_id"
  add_foreign_key "projects", "organizations"
  add_foreign_key "stories", "boards"
  add_foreign_key "stories", "projects"
  add_foreign_key "stories", "users"
  add_foreign_key "stories", "users", column: "last_updated_by_id"
  add_foreign_key "stories", "users", column: "owner_id"
  add_foreign_key "webhooks", "boards"
  add_foreign_key "webhooks", "projects"
  add_foreign_key "webhooks", "users", column: "created_by_id"
end
