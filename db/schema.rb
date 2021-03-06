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

ActiveRecord::Schema.define(version: 2021_05_26_195202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "key", null: false
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wikipedia_key"
    t.string "also_known_as"
    t.integer "mechanics"
    t.index ["key"], name: "index_activities_on_key", unique: true
    t.index ["name"], name: "index_activities_on_name"
    t.index ["parent_id"], name: "index_activities_on_parent_id"
  end

  create_table "activities_offerings", id: false, force: :cascade do |t|
    t.bigint "offering_id", null: false
    t.bigint "activity_id", null: false
    t.index ["activity_id", "offering_id"], name: "index_activities_offers_on_activity_id_and_offer_id"
    t.index ["offering_id", "activity_id"], name: "index_activities_offers_on_offer_id_and_activity_id"
  end

  create_table "activities_organizations", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "activity_id", null: false
    t.index ["activity_id", "organization_id"], name: "index_activities_orgs_on_activity_id_and_org_id"
    t.index ["organization_id", "activity_id"], name: "index_activities_orgs_on_org_id_and_activity_id"
  end

  create_table "activity_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "activity_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "activity_desc_idx"
  end

  create_table "disabilities", force: :cascade do |t|
    t.string "key", null: false
    t.string "name"
    t.string "description"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "wikipedia_key"
    t.index ["key"], name: "index_disabilities_on_key", unique: true
    t.index ["name"], name: "index_disabilities_on_name"
    t.index ["parent_id"], name: "index_disabilities_on_parent_id"
  end

  create_table "disabilities_offerings", id: false, force: :cascade do |t|
    t.bigint "offering_id", null: false
    t.bigint "disability_id", null: false
    t.index ["disability_id", "offering_id"], name: "index_disabilities_offers_on_disability_id_and_offer_id"
    t.index ["offering_id", "disability_id"], name: "index_disabilities_offers_on_offer_id_and_disability_id"
  end

  create_table "disabilities_organizations", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "disability_id", null: false
    t.index ["disability_id", "organization_id"], name: "index_disabilities_orgs_on_disability_id_and_org_id"
    t.index ["organization_id", "disability_id"], name: "index_disabilities_orgs_on_org_id_and_disability_id"
  end

  create_table "disability_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "disability_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "disability_desc_idx"
  end

  create_table "grants", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "eligibility_notes"
    t.text "application_notes"
  end

  create_table "links", force: :cascade do |t|
    t.string "text"
    t.string "url"
    t.string "linkable_type", null: false
    t.bigint "linkable_id", null: false
    t.integer "kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable"
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id"
  end

  create_table "offerings", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.bigint "organization_id", null: false
    t.string "offerable_type"
    t.integer "offerable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "summary"
    t.index ["key"], name: "index_offerings_on_key", unique: true
    t.index ["name"], name: "index_offerings_on_name"
    t.index ["organization_id"], name: "index_offerings_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "key", null: false
    t.boolean "nonprofit", default: false
    t.string "nonprofit_identifier"
    t.index ["key"], name: "index_organizations_on_key", unique: true
  end

  add_foreign_key "offerings", "organizations"
end
