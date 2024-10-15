

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


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."department" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" character varying NOT NULL,
    "organization_id" "uuid"
);


ALTER TABLE "public"."department" OWNER TO "postgres";


COMMENT ON TABLE "public"."department" IS 'department are bellow the organization and each department have organization users to it';



ALTER TABLE "public"."department" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."department_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."department_users" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "organization_user_id" "uuid",
    "department_id" bigint
);


ALTER TABLE "public"."department_users" OWNER TO "postgres";


COMMENT ON TABLE "public"."department_users" IS 'department users are kept here there department id and organization_user id';



ALTER TABLE "public"."department_users" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."department_users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" character varying
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


ALTER TABLE "public"."orders" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."orders_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."organization_users" (
    "organization_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "role_id" integer DEFAULT 5,
    "is_admin" boolean DEFAULT false,
    "added_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."organization_users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."organizations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" character varying(255) NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"()
);


ALTER TABLE "public"."organizations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_types" (
    "id" bigint NOT NULL,
    "name" character varying NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "display_name" "text"
);


ALTER TABLE "public"."product_types" OWNER TO "postgres";


COMMENT ON TABLE "public"."product_types" IS 'Stores the various product or service types offered by the company, serving as a reference for catalog management and workflow automation.';



ALTER TABLE "public"."product_types" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."product_types_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."question_template" (
    "id" bigint NOT NULL,
    "questions" "json" NOT NULL,
    "product_type_id" integer NOT NULL
);


ALTER TABLE "public"."question_template" OWNER TO "postgres";


COMMENT ON TABLE "public"."question_template" IS 'Stores predefined sets of questions for different product types for workflow automation';



ALTER TABLE "public"."question_template" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."questions_template_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" integer NOT NULL,
    "name" character varying(50) NOT NULL
);


ALTER TABLE "public"."roles" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."roles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."roles_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."roles_id_seq" OWNED BY "public"."roles"."id";



CREATE TABLE IF NOT EXISTS "public"."step_types" (
    "id" integer NOT NULL,
    "name" character varying(50) NOT NULL,
    "display_name" character varying(100) NOT NULL
);


ALTER TABLE "public"."step_types" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."step_types_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."step_types_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."step_types_id_seq" OWNED BY "public"."step_types"."id";



CREATE TABLE IF NOT EXISTS "public"."steps" (
    "id" bigint NOT NULL,
    "workflow_id" bigint NOT NULL,
    "type" "text" NOT NULL,
    "order" integer NOT NULL,
    "config" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."steps" OWNER TO "postgres";


COMMENT ON TABLE "public"."steps" IS 'Contains the individual steps that make up each workflow. Each step is linked to a specific workflow and includes information about it.';



ALTER TABLE "public"."steps" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."steps_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "email" character varying(255) NOT NULL,
    "full_name" character varying(255) NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "social_id" bigint
);


ALTER TABLE "public"."users" OWNER TO "postgres";


COMMENT ON COLUMN "public"."users"."social_id" IS 'it is for registration with auth';



CREATE TABLE IF NOT EXISTS "public"."workflows" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "product_type" character varying(255),
    "status" "text" DEFAULT 'draft'::"text"
);


ALTER TABLE "public"."workflows" OWNER TO "postgres";


COMMENT ON TABLE "public"."workflows" IS 'Stores information about individual workflows. Each workflow represents a series of steps for a specific process/task.';



ALTER TABLE "public"."workflows" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."workflows_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."roles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."roles_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."step_types" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."step_types_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."department"
    ADD CONSTRAINT "department_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."department_users"
    ADD CONSTRAINT "department_users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."organization_users"
    ADD CONSTRAINT "organization_users_pkey" PRIMARY KEY ("organization_id", "user_id");



ALTER TABLE ONLY "public"."organization_users"
    ADD CONSTRAINT "organization_users_user_id_key" UNIQUE ("user_id");



ALTER TABLE ONLY "public"."organizations"
    ADD CONSTRAINT "organizations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_types"
    ADD CONSTRAINT "product_types_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."question_template"
    ADD CONSTRAINT "questions_template_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."step_types"
    ADD CONSTRAINT "step_types_name_key" UNIQUE ("name");



ALTER TABLE ONLY "public"."step_types"
    ADD CONSTRAINT "step_types_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."steps"
    ADD CONSTRAINT "steps_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_social_id_key" UNIQUE ("social_id");



ALTER TABLE ONLY "public"."workflows"
    ADD CONSTRAINT "workflows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."department"
    ADD CONSTRAINT "department_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."department_users"
    ADD CONSTRAINT "department_users_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "public"."department"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."department_users"
    ADD CONSTRAINT "department_users_organization_user_id_fkey" FOREIGN KEY ("organization_user_id") REFERENCES "public"."organization_users"("user_id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."organization_users"
    ADD CONSTRAINT "organization_users_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "public"."organizations"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."organization_users"
    ADD CONSTRAINT "organization_users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id");



ALTER TABLE ONLY "public"."organization_users"
    ADD CONSTRAINT "organization_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."question_template"
    ADD CONSTRAINT "questions_template_product_type_id_fkey" FOREIGN KEY ("product_type_id") REFERENCES "public"."product_types"("id");



ALTER TABLE ONLY "public"."steps"
    ADD CONSTRAINT "steps_workflow_id_fkey" FOREIGN KEY ("workflow_id") REFERENCES "public"."workflows"("id");



ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_types" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."question_template" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."steps" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."workflows" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



































































































































































































GRANT ALL ON TABLE "public"."department" TO "anon";
GRANT ALL ON TABLE "public"."department" TO "authenticated";
GRANT ALL ON TABLE "public"."department" TO "service_role";



GRANT ALL ON SEQUENCE "public"."department_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."department_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."department_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."department_users" TO "anon";
GRANT ALL ON TABLE "public"."department_users" TO "authenticated";
GRANT ALL ON TABLE "public"."department_users" TO "service_role";



GRANT ALL ON SEQUENCE "public"."department_users_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."department_users_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."department_users_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT ALL ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."orders_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."organization_users" TO "anon";
GRANT ALL ON TABLE "public"."organization_users" TO "authenticated";
GRANT ALL ON TABLE "public"."organization_users" TO "service_role";



GRANT ALL ON TABLE "public"."organizations" TO "anon";
GRANT ALL ON TABLE "public"."organizations" TO "authenticated";
GRANT ALL ON TABLE "public"."organizations" TO "service_role";



GRANT ALL ON TABLE "public"."product_types" TO "anon";
GRANT ALL ON TABLE "public"."product_types" TO "authenticated";
GRANT ALL ON TABLE "public"."product_types" TO "service_role";



GRANT ALL ON SEQUENCE "public"."product_types_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."product_types_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."product_types_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."question_template" TO "anon";
GRANT ALL ON TABLE "public"."question_template" TO "authenticated";
GRANT ALL ON TABLE "public"."question_template" TO "service_role";



GRANT ALL ON SEQUENCE "public"."questions_template_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."questions_template_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."questions_template_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."roles_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."roles_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."roles_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."step_types" TO "anon";
GRANT ALL ON TABLE "public"."step_types" TO "authenticated";
GRANT ALL ON TABLE "public"."step_types" TO "service_role";



GRANT ALL ON SEQUENCE "public"."step_types_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."step_types_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."step_types_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."steps" TO "anon";
GRANT ALL ON TABLE "public"."steps" TO "authenticated";
GRANT ALL ON TABLE "public"."steps" TO "service_role";



GRANT ALL ON SEQUENCE "public"."steps_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."steps_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."steps_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."workflows" TO "anon";
GRANT ALL ON TABLE "public"."workflows" TO "authenticated";
GRANT ALL ON TABLE "public"."workflows" TO "service_role";



GRANT ALL ON SEQUENCE "public"."workflows_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."workflows_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."workflows_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
