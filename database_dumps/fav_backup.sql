--
-- PostgreSQL database dump
--

\restrict 03dbbVgydXl2eaO4zuIPDJBtovt4oeMmjX4dEdGPOHJoMvTFhsBBEKSsJiXmjlD

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fav; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fav (
    id integer NOT NULL,
    hobby character varying(256) NOT NULL,
    how_much integer NOT NULL
);


ALTER TABLE public.fav OWNER TO postgres;

--
-- Name: fav_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fav_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fav_id_seq OWNER TO postgres;

--
-- Name: fav_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fav_id_seq OWNED BY public.fav.id;


--
-- Name: fav id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fav ALTER COLUMN id SET DEFAULT nextval('public.fav_id_seq'::regclass);


--
-- Data for Name: fav; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fav (id, hobby, how_much) FROM stdin;
5	swim	1
3	reading	2
7	reading	1
4	box	2
\.


--
-- Name: fav_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fav_id_seq', 9, true);


--
-- Name: fav fav_hobby_how_much_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fav
    ADD CONSTRAINT fav_hobby_how_much_key UNIQUE (hobby, how_much);


--
-- Name: fav fav_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fav
    ADD CONSTRAINT fav_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict 03dbbVgydXl2eaO4zuIPDJBtovt4oeMmjX4dEdGPOHJoMvTFhsBBEKSsJiXmjlD

