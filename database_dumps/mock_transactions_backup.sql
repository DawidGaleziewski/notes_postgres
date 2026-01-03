--
-- PostgreSQL database dump
--

\restrict 1iJRdrHSmeC1PAWLowXtOCaJgjavYI9geigFC8FXlucwyxjjKnWfIU2E0pFnCFs

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
-- Name: mock_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mock_transactions (
    id integer NOT NULL,
    amount numeric(14,2) NOT NULL,
    account_id integer,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    error_code character varying(128),
    uniq character varying(128)
);


ALTER TABLE public.mock_transactions OWNER TO postgres;

--
-- Name: mock_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mock_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mock_transactions_id_seq OWNER TO postgres;

--
-- Name: mock_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mock_transactions_id_seq OWNED BY public.mock_transactions.id;


--
-- Name: mock_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_transactions ALTER COLUMN id SET DEFAULT nextval('public.mock_transactions_id_seq'::regclass);


--
-- Data for Name: mock_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mock_transactions (id, amount, account_id, "timestamp", error_code, uniq) FROM stdin;
1	100.00	1	2025-12-26 13:22:29.39687+01	\N	\N
2	200.00	2	2025-12-26 13:22:29.39687+01	\N	\N
3	300.00	3	2025-12-26 13:22:29.39687+01	\N	\N
4	100.00	1	2025-12-26 13:23:39.645752+01	\N	\N
5	200.00	2	2025-12-26 13:23:39.645752+01	\N	\N
6	300.00	3	2025-12-26 13:23:39.645752+01	\N	\N
7	100.00	1	2025-12-26 13:23:59.307499+01	\N	\N
8	200.00	2	2025-12-26 13:23:59.307499+01	\N	\N
9	300.00	3	2025-12-26 13:23:59.307499+01	\N	\N
12	100.00	1	2025-12-26 13:37:00.446634+01	\N	\N
13	200.00	2	2025-12-26 13:37:00.446634+01	\N	\N
14	300.00	3	2025-12-26 13:37:00.446634+01	\N	\N
15	0.00	1	2025-12-26 13:40:22.24183+01	something went wrong!	c
24	100.00	1	2025-12-26 14:26:40.638317+01	\N	\N
\.


--
-- Name: mock_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mock_transactions_id_seq', 24, true);


--
-- Name: mock_transactions mock_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_transactions
    ADD CONSTRAINT mock_transactions_pkey PRIMARY KEY (id);


--
-- Name: mock_transactions mock_transactions_uniq_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_transactions
    ADD CONSTRAINT mock_transactions_uniq_key UNIQUE (uniq);


--
-- Name: mock_transactions mock_transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_transactions
    ADD CONSTRAINT mock_transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 1iJRdrHSmeC1PAWLowXtOCaJgjavYI9geigFC8FXlucwyxjjKnWfIU2E0pFnCFs

