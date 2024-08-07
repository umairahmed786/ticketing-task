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

ActiveRecord::Schema.define(version: 2024_08_07_012417) do

  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "file_path"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_attachments_on_organization_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_comments_on_organization_id"
  end

  create_table "field_changes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "field"
    t.string "old_value"
    t.string "new_value"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_field_changes_on_organization_id"
  end

  create_table "issue_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "field_change_id"
    t.bigint "attachment_id"
    t.bigint "comment_id"
    t.bigint "issue_id", null: false
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachment_id"], name: "index_issue_histories_on_attachment_id"
    t.index ["comment_id"], name: "index_issue_histories_on_comment_id"
    t.index ["field_change_id"], name: "index_issue_histories_on_field_change_id"
    t.index ["issue_id"], name: "index_issue_histories_on_issue_id"
    t.index ["organization_id"], name: "index_issue_histories_on_organization_id"
    t.index ["user_id"], name: "index_issue_histories_on_user_id"
  end

  create_table "issues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "state"
    t.integer "complexity_point"
    t.bigint "project_id", null: false
    t.bigint "assignee_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assignee_id"], name: "index_issues_on_assignee_id"
    t.index ["organization_id"], name: "index_issues_on_organization_id"
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "organizations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_project_users_on_organization_id"
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "admin_id", null: false
    t.bigint "project_manager_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_projects_on_admin_id"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
    t.index ["project_manager_id"], name: "index_projects_on_project_manager_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "role_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "attachments", "organizations"
  add_foreign_key "comments", "organizations"
  add_foreign_key "field_changes", "organizations"
  add_foreign_key "issue_histories", "attachments"
  add_foreign_key "issue_histories", "comments"
  add_foreign_key "issue_histories", "field_changes"
  add_foreign_key "issue_histories", "issues"
  add_foreign_key "issue_histories", "organizations"
  add_foreign_key "issue_histories", "users"
  add_foreign_key "issues", "organizations"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users", column: "assignee_id"
  add_foreign_key "project_users", "organizations"
  add_foreign_key "project_users", "users"
  add_foreign_key "project_users", "users", column: "project_id"
  add_foreign_key "projects", "organizations"
  add_foreign_key "projects", "users", column: "admin_id"
  add_foreign_key "projects", "users", column: "project_manager_id"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "roles"
end
