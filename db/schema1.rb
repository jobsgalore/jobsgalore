# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema1.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170310100000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carearones", id: :integer, default: -> { "nextval('carearone_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title_job"
    t.text   "descriptions"
    t.string "type"
    t.string "category"
    t.string "location"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "phone"
    t.string   "password"
    t.boolean  "responsible"
    t.string   "photo_uid"
    t.boolean  "gender"
    t.integer  "location_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_clients_on_email", using: :btree
    t.index ["location_id"], name: "index_clients_on_location_id", using: :btree
    t.index ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true, using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.integer  "size_id"
    t.integer  "location_id"
    t.string   "site"
    t.string   "logo"
    t.boolean  "recrutmentagency"
    t.string   "description"
    t.boolean  "realy"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index "to_tsvector('english'::regconfig, (((((name)::text || ' '::text) || (site)::text) || ' '::text) || (description)::text))", name: "companies_idx", using: :gin
    t.index ["location_id"], name: "index_companies_on_location_id", using: :btree
    t.index ["name"], name: "index_companies_on_name", using: :btree
    t.index ["size_id"], name: "index_companies_on_size_id", using: :btree
  end

  create_table "educations", force: :cascade do |t|
    t.string   "education"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "employer",    null: false
    t.integer  "location_id"
    t.string   "site"
    t.string   "titlejob",    null: false
    t.date     "datestart"
    t.date     "dateend"
    t.string   "description"
    t.integer  "resume_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["location_id"], name: "index_experiences_on_location_id", using: :btree
    t.index ["resume_id"], name: "index_experiences_on_resume_id", using: :btree
  end

  create_table "industries", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "industry_id"
    t.integer  "level",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["industry_id"], name: "index_industries_on_industry_id", using: :btree
    t.index ["name"], name: "index_industries_on_name", using: :btree
  end

  create_table "industrycompanies", force: :cascade do |t|
    t.integer  "industry_id"
    t.integer  "company_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["company_id"], name: "index_industrycompanies_on_company_id", using: :btree
    t.index ["industry_id"], name: "index_industrycompanies_on_industry_id", using: :btree
  end

  create_table "industryexperiences", force: :cascade do |t|
    t.integer  "industry_id"
    t.integer  "experience_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["experience_id"], name: "index_industryexperiences_on_experience_id", using: :btree
    t.index ["industry_id"], name: "index_industryexperiences_on_industry_id", using: :btree
  end

  create_table "industryjobs", force: :cascade do |t|
    t.integer  "industry_id"
    t.integer  "job_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["industry_id"], name: "index_industryjobs_on_industry_id", using: :btree
    t.index ["job_id"], name: "index_industryjobs_on_job_id", using: :btree
  end

  create_table "industryresumes", force: :cascade do |t|
    t.integer  "industry_id"
    t.integer  "resume_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["industry_id"], name: "index_industryresumes_on_industry_id", using: :btree
    t.index ["resume_id"], name: "index_industryresumes_on_resume_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.integer  "location_id"
    t.float    "salarymin"
    t.float    "salarymax"
    t.boolean  "permanent"
    t.boolean  "casual"
    t.boolean  "temp"
    t.boolean  "contract"
    t.boolean  "fulltime"
    t.boolean  "parttime"
    t.boolean  "flextime"
    t.boolean  "remote"
    t.string   "description"
    t.integer  "company_id"
    t.integer  "education_id"
    t.string   "career"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index "to_tsvector('english'::regconfig, (((((title)::text || ' '::text) || (description)::text) || ' '::text) || (career)::text))", name: "jobs_idx", using: :gin
    t.index ["company_id"], name: "index_jobs_on_company_id", using: :btree
    t.index ["created_at"], name: "index_jobs_on_created_at", using: :btree
    t.index ["education_id"], name: "index_jobs_on_education_id", using: :btree
    t.index ["location_id"], name: "index_jobs_on_location_id", using: :btree
    t.index ["salarymax"], name: "index_jobs_on_salarymax", using: :btree
    t.index ["salarymin"], name: "index_jobs_on_salarymin", using: :btree
    t.index ["updated_at"], name: "index_jobs_on_updated_at", using: :btree
  end

  create_table "languageresumes", force: :cascade do |t|
    t.integer  "resume_id"
    t.integer  "language_id"
    t.integer  "level_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["language_id"], name: "index_languageresumes_on_language_id", using: :btree
    t.index ["level_id"], name: "index_languageresumes_on_level_id", using: :btree
    t.index ["resume_id"], name: "index_languageresumes_on_resume_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string   "name",       null: false
    t.boolean  "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "postcode"
    t.string   "suburb"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
    t.tsvector "fts"
    t.index ["fts"], name: "index_locations_on_fts", using: :gin
    t.index ["parent_id"], name: "index_locations_on_parent_id", using: :btree
  end

  create_table "properts", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responsibles", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_responsibles_on_client_id", using: :btree
    t.index ["company_id"], name: "index_responsibles_on_company_id", using: :btree
  end

  create_table "resumes", force: :cascade do |t|
    t.string   "desiredjobtitle", null: false
    t.float    "salary"
    t.boolean  "permanent"
    t.boolean  "casual"
    t.boolean  "temp"
    t.boolean  "contract"
    t.boolean  "fulltime"
    t.boolean  "parttime"
    t.boolean  "flextime"
    t.boolean  "remote"
    t.string   "abouteme"
    t.integer  "client_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index "to_tsvector('english'::regconfig, (((desiredjobtitle)::text || ' '::text) || (abouteme)::text))", name: "resumes_idx", using: :gin
    t.index ["client_id"], name: "index_resumes_on_client_id", using: :btree
    t.index ["created_at"], name: "index_resumes_on_created_at", using: :btree
    t.index ["salary"], name: "index_resumes_on_salary", using: :btree
    t.index ["updated_at"], name: "index_resumes_on_updated_at", using: :btree
  end

  create_table "sizes", force: :cascade do |t|
    t.string   "size",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skillsjobs", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "level_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_skillsjobs_on_job_id", using: :btree
    t.index ["level_id"], name: "index_skillsjobs_on_level_id", using: :btree
    t.index ["name"], name: "index_skillsjobs_on_name", using: :btree
  end

  create_table "skillsresumes", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "level_id"
    t.integer  "resume_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level_id"], name: "index_skillsresumes_on_level_id", using: :btree
    t.index ["name"], name: "index_skillsresumes_on_name", using: :btree
    t.index ["resume_id"], name: "index_skillsresumes_on_resume_id", using: :btree
  end

  add_foreign_key "clients", "locations"
  add_foreign_key "companies", "locations"
  add_foreign_key "companies", "sizes"
  add_foreign_key "experiences", "locations"
  add_foreign_key "experiences", "resumes"
  add_foreign_key "industries", "industries"
  add_foreign_key "industrycompanies", "companies"
  add_foreign_key "industrycompanies", "industries"
  add_foreign_key "industryexperiences", "experiences"
  add_foreign_key "industryexperiences", "industries"
  add_foreign_key "industryjobs", "industries"
  add_foreign_key "industryjobs", "jobs"
  add_foreign_key "industryresumes", "industries"
  add_foreign_key "industryresumes", "resumes"
  add_foreign_key "jobs", "companies"
  add_foreign_key "jobs", "educations"
  add_foreign_key "jobs", "locations"
  add_foreign_key "languageresumes", "languages"
  add_foreign_key "languageresumes", "levels"
  add_foreign_key "languageresumes", "resumes"
  add_foreign_key "responsibles", "clients"
  add_foreign_key "responsibles", "companies"
  add_foreign_key "resumes", "clients"
  add_foreign_key "skillsjobs", "jobs"
  add_foreign_key "skillsjobs", "levels"
  add_foreign_key "skillsresumes", "levels"
  add_foreign_key "skillsresumes", "resumes"
end
