SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: companies_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.companies_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$;


--
-- Name: jobs_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jobs_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      begin
        new.fts :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A') ||
            setweight(to_tsvector('pg_catalog.english', coalesce(new.description,'')), 'D');
        return new;
      end
      $$;


--
-- Name: resumes_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.resumes_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
      new.fts :=
          setweight(to_tsvector('pg_catalog.english', coalesce(new.desiredjobtitle,'')), 'A') ||
          setweight(to_tsvector('pg_catalog.english', coalesce(new.abouteme,'')), 'D');
      return new;
    end
    $$;


--
-- Name: user_rank(tsvector, text, text, text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.user_rank(field tsvector, query_full text, query text, mode_execute text[]) RETURNS real
    LANGUAGE plpgsql
    AS $$
      DECLARE rank_by_query float4;
      begin
        rank_by_query := 0;
        if (rank_by_query = 0 and ARRAY['phrase'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, phraseto_tsquery(query_full))*1000;
        end if;
        if (rank_by_query = 0 and ARRAY['plain'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, plainto_tsquery(query_full))*50;
        end if;
        if (rank_by_query = 0 and ARRAY['none'] <@ mode_execute) then
          rank_by_query := ts_rank_cd(field, to_tsquery(query));
        end if;
        return rank_by_query;
      end;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: clientforalerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientforalerts (
    id bigint NOT NULL,
    email character varying,
    key character varying,
    location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    send_email boolean DEFAULT true
);


--
-- Name: clientforalerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientforalerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clientforalerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clientforalerts_id_seq OWNED BY public.clientforalerts.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    firstname character varying NOT NULL,
    lastname character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    phone character varying,
    password character varying,
    photo_uid character varying,
    gender boolean,
    location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    birth date,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    "character" character varying,
    send_email boolean DEFAULT true NOT NULL,
    company_id integer,
    provider character varying,
    uid character varying,
    sources character varying,
    token character varying,
    alert boolean DEFAULT true NOT NULL
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying,
    size_id integer,
    location_id integer,
    site character varying,
    logo_uid character varying,
    recrutmentagency boolean,
    description character varying,
    realy boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    industry_id integer,
    big boolean DEFAULT false NOT NULL,
    names character varying[]
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: deleted_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deleted_jobs (
    id bigint NOT NULL,
    original_id integer,
    title character varying,
    location_id bigint,
    salarymin double precision,
    salarymax double precision,
    description character varying,
    begin date,
    company_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: deleted_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deleted_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deleted_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deleted_jobs_id_seq OWNED BY public.deleted_jobs.id;


--
-- Name: email_hrs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_hrs (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    company_id bigint,
    phone character varying,
    send_email boolean,
    contact boolean,
    location_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fio character varying,
    main boolean
);


--
-- Name: email_hrs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_hrs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_hrs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_hrs_id_seq OWNED BY public.email_hrs.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emails (
    id integer NOT NULL,
    email character varying,
    arr jsonb[] DEFAULT '{}'::jsonb[]
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- Name: experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiences (
    id integer NOT NULL,
    employer character varying NOT NULL,
    location_id integer,
    site character varying,
    titlejob character varying NOT NULL,
    datestart date,
    dateend date,
    description character varying,
    resume_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.experiences_id_seq OWNED BY public.experiences.id;


--
-- Name: experiments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiments (
    id bigint NOT NULL,
    name character varying,
    variant character varying,
    params jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: experiments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.experiments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.experiments_id_seq OWNED BY public.experiments.id;


--
-- Name: gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gateways (
    id integer NOT NULL,
    company_id integer,
    client_id integer,
    location_id integer,
    industry_id integer,
    script character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    log character varying,
    hashtags character varying
);


--
-- Name: gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gateways_id_seq OWNED BY public.gateways.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id integer NOT NULL,
    name character varying NOT NULL,
    industry_id integer,
    level integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industries_id_seq OWNED BY public.industries.id;


--
-- Name: industryexperiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industryexperiences (
    id integer NOT NULL,
    industry_id integer,
    experience_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industryexperiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industryexperiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industryexperiences_id_seq OWNED BY public.industryexperiences.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    title character varying,
    location_id integer,
    salarymin double precision,
    salarymax double precision,
    description character varying,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    highlight date,
    top date,
    urgent date,
    client_id integer,
    close date,
    industry_id integer,
    sources character varying,
    apply character varying,
    viewed_count integer
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    postcode character varying,
    suburb character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id integer,
    fts tsvector,
    counts_jobs integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: mailings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailings (
    id bigint NOT NULL,
    client_id bigint,
    message character varying,
    resume_id bigint,
    price double precision,
    offices jsonb[] DEFAULT '{}'::jsonb[],
    type_letter character varying,
    aasm_state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cur character varying
);


--
-- Name: mailings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailings_id_seq OWNED BY public.mailings.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    product_id bigint,
    params jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    payment_id bigint,
    aasm_state character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    params text,
    product_id integer,
    kind integer,
    kindpay integer,
    status character varying,
    transaction_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    addition jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    price jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: properts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.properts (
    id integer NOT NULL,
    code character varying,
    name character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: properts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.properts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: properts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.properts_id_seq OWNED BY public.properts.id;


--
-- Name: respondeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.respondeds (
    id bigint NOT NULL,
    client_id integer,
    ip character varying,
    lang character varying,
    agent character varying,
    doc_id integer,
    doc_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: respondeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.respondeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: respondeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.respondeds_id_seq OWNED BY public.respondeds.id;


--
-- Name: resumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resumes (
    id integer NOT NULL,
    desiredjobtitle character varying NOT NULL,
    salary double precision,
    abouteme character varying,
    client_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fts tsvector,
    location_id integer,
    highlight date,
    top date,
    urgent date,
    industry_id integer,
    sources character varying,
    viewed_count integer
);


--
-- Name: resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resumes_id_seq OWNED BY public.resumes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sizes (
    id integer NOT NULL,
    size character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sizes_id_seq OWNED BY public.sizes.id;


--
-- Name: vieweds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vieweds (
    id bigint NOT NULL,
    client_id integer,
    ip character varying,
    lang character varying,
    agent character varying,
    doc_id integer,
    doc_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: vieweds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vieweds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vieweds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vieweds_id_seq OWNED BY public.vieweds.id;


--
-- Name: clientforalerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientforalerts ALTER COLUMN id SET DEFAULT nextval('public.clientforalerts_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: deleted_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_jobs ALTER COLUMN id SET DEFAULT nextval('public.deleted_jobs_id_seq'::regclass);


--
-- Name: email_hrs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_hrs ALTER COLUMN id SET DEFAULT nextval('public.email_hrs_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- Name: experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences ALTER COLUMN id SET DEFAULT nextval('public.experiences_id_seq'::regclass);


--
-- Name: experiments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiments ALTER COLUMN id SET DEFAULT nextval('public.experiments_id_seq'::regclass);


--
-- Name: gateways id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways ALTER COLUMN id SET DEFAULT nextval('public.gateways_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries ALTER COLUMN id SET DEFAULT nextval('public.industries_id_seq'::regclass);


--
-- Name: industryexperiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences ALTER COLUMN id SET DEFAULT nextval('public.industryexperiences_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: mailings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings ALTER COLUMN id SET DEFAULT nextval('public.mailings_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: properts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properts ALTER COLUMN id SET DEFAULT nextval('public.properts_id_seq'::regclass);


--
-- Name: respondeds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respondeds ALTER COLUMN id SET DEFAULT nextval('public.respondeds_id_seq'::regclass);


--
-- Name: resumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes ALTER COLUMN id SET DEFAULT nextval('public.resumes_id_seq'::regclass);


--
-- Name: sizes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sizes ALTER COLUMN id SET DEFAULT nextval('public.sizes_id_seq'::regclass);


--
-- Name: vieweds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vieweds ALTER COLUMN id SET DEFAULT nextval('public.vieweds_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: clientforalerts clientforalerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientforalerts
    ADD CONSTRAINT clientforalerts_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: deleted_jobs deleted_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_jobs
    ADD CONSTRAINT deleted_jobs_pkey PRIMARY KEY (id);


--
-- Name: email_hrs email_hrs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_hrs
    ADD CONSTRAINT email_hrs_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: experiments experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: gateways gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT gateways_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: industryexperiences industryexperiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT industryexperiences_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mailings mailings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings
    ADD CONSTRAINT mailings_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: properts properts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properts
    ADD CONSTRAINT properts_pkey PRIMARY KEY (id);


--
-- Name: respondeds respondeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.respondeds
    ADD CONSTRAINT respondeds_pkey PRIMARY KEY (id);


--
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sizes sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sizes
    ADD CONSTRAINT sizes_pkey PRIMARY KEY (id);


--
-- Name: vieweds vieweds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vieweds
    ADD CONSTRAINT vieweds_pkey PRIMARY KEY (id);


--
-- Name: index_clients_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_company_id ON public.clients USING btree (company_id);


--
-- Name: index_clients_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_confirmation_token ON public.clients USING btree (confirmation_token);


--
-- Name: index_clients_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_email ON public.clients USING btree (email);


--
-- Name: index_clients_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_location_id ON public.clients USING btree (location_id);


--
-- Name: index_clients_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_reset_password_token ON public.clients USING btree (reset_password_token);


--
-- Name: index_clients_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_unlock_token ON public.clients USING btree (unlock_token);


--
-- Name: index_companies_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_fts ON public.companies USING gin (fts);


--
-- Name: index_companies_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_industry_id ON public.companies USING btree (industry_id);


--
-- Name: index_companies_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_location_id ON public.companies USING btree (location_id);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON public.companies USING btree (name);


--
-- Name: index_companies_on_size_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_size_id ON public.companies USING btree (size_id);


--
-- Name: index_deleted_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deleted_jobs_on_company_id ON public.deleted_jobs USING btree (company_id);


--
-- Name: index_deleted_jobs_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deleted_jobs_on_location_id ON public.deleted_jobs USING btree (location_id);


--
-- Name: index_deleted_jobs_on_original_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deleted_jobs_on_original_id ON public.deleted_jobs USING btree (original_id);


--
-- Name: index_email_hrs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_hrs_on_company_id ON public.email_hrs USING btree (company_id);


--
-- Name: index_email_hrs_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_email_hrs_on_email ON public.email_hrs USING btree (email);


--
-- Name: index_email_hrs_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_hrs_on_location_id ON public.email_hrs USING btree (location_id);


--
-- Name: index_experiences_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_location_id ON public.experiences USING btree (location_id);


--
-- Name: index_experiences_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_resume_id ON public.experiences USING btree (resume_id);


--
-- Name: index_gateways_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_client_id ON public.gateways USING btree (client_id);


--
-- Name: index_gateways_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_company_id ON public.gateways USING btree (company_id);


--
-- Name: index_gateways_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_industry_id ON public.gateways USING btree (industry_id);


--
-- Name: index_gateways_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gateways_on_location_id ON public.gateways USING btree (location_id);


--
-- Name: index_industries_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_industry_id ON public.industries USING btree (industry_id);


--
-- Name: index_industries_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industries_on_name ON public.industries USING btree (name);


--
-- Name: index_industryexperiences_on_experience_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_experience_id ON public.industryexperiences USING btree (experience_id);


--
-- Name: index_industryexperiences_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_industryexperiences_on_industry_id ON public.industryexperiences USING btree (industry_id);


--
-- Name: index_jobs_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_client_id ON public.jobs USING btree (client_id);


--
-- Name: index_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_company_id ON public.jobs USING btree (company_id);


--
-- Name: index_jobs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_created_at ON public.jobs USING btree (created_at);


--
-- Name: index_jobs_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_fts ON public.jobs USING gin (fts);


--
-- Name: index_jobs_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_industry_id ON public.jobs USING btree (industry_id);


--
-- Name: index_jobs_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_location_id ON public.jobs USING btree (location_id);


--
-- Name: index_jobs_on_salarymax; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymax ON public.jobs USING btree (salarymax);


--
-- Name: index_jobs_on_salarymin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_salarymin ON public.jobs USING btree (salarymin);


--
-- Name: index_jobs_on_sources; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_sources ON public.jobs USING btree (sources);


--
-- Name: index_jobs_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_updated_at ON public.jobs USING btree (updated_at);


--
-- Name: index_jobs_on_urgent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_urgent ON public.jobs USING btree (urgent);


--
-- Name: index_locations_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_fts ON public.locations USING gin (fts);


--
-- Name: index_locations_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_parent_id ON public.locations USING btree (parent_id);


--
-- Name: index_mailings_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailings_on_client_id ON public.mailings USING btree (client_id);


--
-- Name: index_mailings_on_resume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailings_on_resume_id ON public.mailings USING btree (resume_id);


--
-- Name: index_orders_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_payment_id ON public.orders USING btree (payment_id);


--
-- Name: index_orders_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_product_id ON public.orders USING btree (product_id);


--
-- Name: index_respondeds_on_doc_id_and_doc_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_respondeds_on_doc_id_and_doc_type ON public.respondeds USING btree (doc_id, doc_type);


--
-- Name: index_resumes_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_client_id ON public.resumes USING btree (client_id);


--
-- Name: index_resumes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_created_at ON public.resumes USING btree (created_at);


--
-- Name: index_resumes_on_fts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_fts ON public.resumes USING gin (fts);


--
-- Name: index_resumes_on_industry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_industry_id ON public.resumes USING btree (industry_id);


--
-- Name: index_resumes_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_location_id ON public.resumes USING btree (location_id);


--
-- Name: index_resumes_on_salary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_salary ON public.resumes USING btree (salary);


--
-- Name: index_resumes_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resumes_on_updated_at ON public.resumes USING btree (updated_at);


--
-- Name: index_vieweds_on_doc_id_and_doc_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vieweds_on_doc_id_and_doc_type ON public.vieweds USING btree (doc_id, doc_type);


--
-- Name: companies tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.companies FOR EACH ROW EXECUTE PROCEDURE public.companies_trigger();


--
-- Name: jobs tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.jobs FOR EACH ROW EXECUTE PROCEDURE public.jobs_trigger();


--
-- Name: locations tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.locations FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('fts', 'pg_catalog.english', 'suburb', 'postcode', 'state');


--
-- Name: resumes tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON public.resumes FOR EACH ROW EXECUTE PROCEDURE public.resumes_trigger();


--
-- Name: resumes fk_rails_003565a9fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_003565a9fb FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: industries fk_rails_032ff5b3d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT fk_rails_032ff5b3d0 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: companies fk_rails_1e99f51bd6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_1e99f51bd6 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: gateways fk_rails_3476d36c73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_3476d36c73 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: email_hrs fk_rails_3e2309a3ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_hrs
    ADD CONSTRAINT fk_rails_3e2309a3ab FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: industryexperiences fk_rails_493fe47dba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT fk_rails_493fe47dba FOREIGN KEY (experience_id) REFERENCES public.experiences(id);


--
-- Name: mailings fk_rails_57b95fc162; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings
    ADD CONSTRAINT fk_rails_57b95fc162 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: resumes fk_rails_58be162534; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_58be162534 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: jobs fk_rails_5b8502059e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_5b8502059e FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: deleted_jobs fk_rails_662a38c691; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_jobs
    ADD CONSTRAINT fk_rails_662a38c691 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: companies fk_rails_81ca530391; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_81ca530391 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: orders fk_rails_84d308e2db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_84d308e2db FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: experiences fk_rails_91959a45b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT fk_rails_91959a45b5 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: gateways fk_rails_9650b12e65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_9650b12e65 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: companies fk_rails_9b863559a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT fk_rails_9b863559a5 FOREIGN KEY (size_id) REFERENCES public.sizes(id);


--
-- Name: deleted_jobs fk_rails_a36d47e766; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deleted_jobs
    ADD CONSTRAINT fk_rails_a36d47e766 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: clients fk_rails_ae769b0e0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT fk_rails_ae769b0e0b FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: experiences fk_rails_b062765ade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT fk_rails_b062765ade FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: gateways fk_rails_b0cc6672a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_b0cc6672a9 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: jobs fk_rails_b34da78090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_b34da78090 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: email_hrs fk_rails_c06729e589; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_hrs
    ADD CONSTRAINT fk_rails_c06729e589 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: mailings fk_rails_c7f9f6df8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings
    ADD CONSTRAINT fk_rails_c7f9f6df8d FOREIGN KEY (resume_id) REFERENCES public.resumes(id);


--
-- Name: industryexperiences fk_rails_cf58b01b64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industryexperiences
    ADD CONSTRAINT fk_rails_cf58b01b64 FOREIGN KEY (industry_id) REFERENCES public.industries(id);


--
-- Name: gateways fk_rails_dec69062e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gateways
    ADD CONSTRAINT fk_rails_dec69062e5 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: orders fk_rails_dfb33b2de0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_dfb33b2de0 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: jobs fk_rails_e1588fa548; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_e1588fa548 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: resumes fk_rails_e57ac8f3e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT fk_rails_e57ac8f3e0 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: jobs fk_rails_f3577d7dd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_f3577d7dd3 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20161216140254'),
('20161216140255'),
('20161216144123'),
('20161216144836'),
('20161216144837'),
('20161216144838'),
('20161216144839'),
('20161216144840'),
('20161216144842'),
('20161216144843'),
('20161216152826'),
('20161216152951'),
('20161216152952'),
('20161216152953'),
('20161216153048'),
('20161220113257'),
('20161220114325'),
('20161220114429'),
('20161220114751'),
('20161221095015'),
('20170125130039'),
('20170228101552'),
('20170310100000'),
('20170330000001'),
('20170430102817'),
('20170430103528'),
('20170621104707'),
('20170630083503'),
('20170703065606'),
('20170706115005'),
('20170909101238'),
('20170925080815'),
('20170925084348'),
('20170925090306'),
('20170925094404'),
('20171115064516'),
('20171115080406'),
('20171115095734'),
('20171116103057'),
('20171120104421'),
('20171227042835'),
('20171227043153'),
('20171228040745'),
('20180204105551'),
('20180218093045'),
('20180601064454'),
('20180717112526'),
('20180719095548'),
('20180720094458'),
('20180904071613'),
('20180913075713'),
('20180924055806'),
('20180925073017'),
('20181114111921'),
('20181130075311'),
('20181203085507'),
('20181207094318'),
('20190116113913'),
('20190201152729'),
('20190212081338'),
('20190416091635'),
('20190514065624'),
('20190514070814'),
('20190517062747'),
('20190517072016'),
('20190531141930'),
('20190621140649'),
('20190923070505'),
('20190923070838'),
('20190923072126'),
('20191003053319'),
('20191011080806'),
('20191011090825'),
('20191120065340'),
('20200115052934'),
('20200130034755'),
('20200214142853'),
('20200317140204');


