--
-- PostgreSQL database dump
--

\restrict 8v8khu7uGx1ED1GoyejQD7UOvuX75z2abuo4GJ60V5XhGluE0dfDgwYrV7H7ORG

-- Dumped from database version 17.10 (Debian 17.10-0+deb13u1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-0+deb13u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: tb_lote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_lote (
    cod_lote integer NOT NULL,
    cod_produto integer,
    dat_validade date NOT NULL,
    int_quantidade integer DEFAULT 0
);


ALTER TABLE public.tb_lote OWNER TO postgres;

--
-- Name: tb_lote_cod_lote_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_lote_cod_lote_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_lote_cod_lote_seq OWNER TO postgres;

--
-- Name: tb_lote_cod_lote_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_lote_cod_lote_seq OWNED BY public.tb_lote.cod_lote;


--
-- Name: tb_movimentacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_movimentacao (
    cod_mov integer NOT NULL,
    cod_produto integer,
    chr_tipo character(1),
    dat_mov timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    int_qtd integer NOT NULL,
    vch_motivo character varying(200),
    CONSTRAINT tb_movimentacao_chr_tipo_check CHECK ((chr_tipo = ANY (ARRAY['E'::bpchar, 'S'::bpchar])))
);


ALTER TABLE public.tb_movimentacao OWNER TO postgres;

--
-- Name: tb_movimentacao_cod_mov_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_movimentacao_cod_mov_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_movimentacao_cod_mov_seq OWNER TO postgres;

--
-- Name: tb_movimentacao_cod_mov_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_movimentacao_cod_mov_seq OWNED BY public.tb_movimentacao.cod_mov;


--
-- Name: tb_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_produto (
    cod_produto integer NOT NULL,
    vch_nome character varying(100) NOT NULL,
    vch_marca character varying(50),
    preco_custo numeric(10,2) DEFAULT 0.00,
    vch_categoria character varying(50),
    preco_venda numeric(10,2) DEFAULT 0.00,
    imagem_url character varying(500)
);


ALTER TABLE public.tb_produto OWNER TO postgres;

--
-- Name: tb_produto_cod_produto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_produto_cod_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_produto_cod_produto_seq OWNER TO postgres;

--
-- Name: tb_produto_cod_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_produto_cod_produto_seq OWNED BY public.tb_produto.cod_produto;


--
-- Name: tb_usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tb_usuario (
    cod_usuario integer NOT NULL,
    vch_email character varying(100) NOT NULL,
    vch_senha character varying(255) NOT NULL
);


ALTER TABLE public.tb_usuario OWNER TO postgres;

--
-- Name: tb_usuario_cod_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tb_usuario_cod_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb_usuario_cod_usuario_seq OWNER TO postgres;

--
-- Name: tb_usuario_cod_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tb_usuario_cod_usuario_seq OWNED BY public.tb_usuario.cod_usuario;


--
-- Name: tb_lote cod_lote; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_lote ALTER COLUMN cod_lote SET DEFAULT nextval('public.tb_lote_cod_lote_seq'::regclass);


--
-- Name: tb_movimentacao cod_mov; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_movimentacao ALTER COLUMN cod_mov SET DEFAULT nextval('public.tb_movimentacao_cod_mov_seq'::regclass);


--
-- Name: tb_produto cod_produto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_produto ALTER COLUMN cod_produto SET DEFAULT nextval('public.tb_produto_cod_produto_seq'::regclass);


--
-- Name: tb_usuario cod_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario ALTER COLUMN cod_usuario SET DEFAULT nextval('public.tb_usuario_cod_usuario_seq'::regclass);


--
-- Data for Name: tb_lote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_lote (cod_lote, cod_produto, dat_validade, int_quantidade) FROM stdin;
1	1	2028-02-04	30
2	2	2029-03-07	30
3	4	2028-05-13	30
4	5	2029-06-16	30
5	6	2027-07-19	30
6	6	2028-08-20	25
7	7	2028-08-22	30
8	9	2027-10-01	30
9	9	2028-11-02	25
10	10	2028-11-04	30
11	11	2029-12-07	30
12	12	2027-01-10	30
13	12	2028-02-11	25
14	14	2029-03-16	30
15	15	2027-04-19	30
16	15	2028-05-20	25
17	16	2028-05-22	30
18	17	2029-06-25	30
19	18	2027-07-01	40
20	18	2028-08-02	35
21	19	2028-08-04	40
22	20	2029-09-07	40
23	21	2027-10-10	40
24	21	2028-11-11	35
25	22	2028-11-13	40
26	23	2029-12-16	40
27	24	2027-01-19	40
28	24	2028-02-20	35
29	25	2028-02-22	40
30	26	2029-03-25	40
31	27	2027-04-01	40
32	27	2028-05-02	35
33	28	2028-05-04	40
34	29	2029-06-07	40
35	30	2027-07-10	40
36	30	2028-08-11	35
37	31	2028-08-13	40
38	32	2029-09-16	40
39	33	2027-10-19	40
40	33	2028-11-20	35
41	34	2028-11-22	40
42	35	2029-12-25	12
43	36	2027-01-01	12
44	36	2028-02-02	17
45	37	2028-02-04	12
46	38	2029-03-07	12
47	39	2027-04-10	12
48	39	2028-05-11	17
49	40	2028-05-13	12
50	41	2029-06-16	12
51	42	2027-07-19	12
52	42	2028-08-20	17
53	43	2028-08-22	12
54	44	2029-09-25	12
55	45	2027-10-01	12
56	45	2028-11-02	17
57	46	2028-11-04	12
58	47	2029-12-07	12
59	48	2027-01-10	12
60	48	2028-02-11	17
61	49	2028-02-13	12
62	50	2029-03-16	12
63	51	2027-04-19	12
64	51	2028-05-20	17
65	52	2028-05-22	60
66	53	2029-06-25	60
67	54	2027-07-01	60
68	54	2028-08-02	50
69	55	2028-08-04	60
70	56	2029-09-07	60
71	57	2027-10-10	60
72	57	2028-11-11	50
73	58	2028-11-13	60
74	59	2029-12-16	60
75	60	2027-01-19	60
76	60	2028-02-20	50
77	61	2028-02-22	60
78	62	2029-03-25	60
79	63	2027-04-01	60
80	63	2028-05-02	50
81	64	2028-05-04	60
82	65	2029-06-07	60
83	66	2027-07-10	60
84	66	2028-08-11	50
85	67	2028-08-13	60
86	68	2029-09-16	60
87	69	2027-10-19	80
88	69	2028-11-20	70
89	70	2028-11-22	80
90	71	2029-12-25	80
91	72	2027-01-01	80
92	72	2028-02-02	70
93	73	2028-02-04	80
94	74	2029-03-07	80
95	75	2027-04-10	80
96	75	2028-05-11	70
97	76	2028-05-13	80
98	77	2029-06-16	80
99	78	2027-07-19	80
100	78	2028-08-20	70
101	79	2028-08-22	80
102	80	2029-09-25	80
103	81	2027-10-01	80
104	81	2028-11-02	70
105	82	2028-11-04	80
106	83	2029-12-07	80
107	84	2027-01-10	80
108	84	2028-02-11	70
109	85	2028-02-13	80
110	86	2029-03-16	50
111	87	2027-04-19	50
112	87	2028-05-20	45
113	89	2029-06-25	50
114	90	2027-07-01	50
115	90	2028-08-02	45
116	91	2028-08-04	50
117	92	2029-09-07	50
118	94	2028-11-13	50
119	95	2029-12-16	50
120	96	2027-01-19	50
121	96	2028-02-20	45
122	97	2028-02-22	50
123	99	2027-04-01	50
124	99	2028-05-02	45
125	100	2028-05-04	50
\.


--
-- Data for Name: tb_movimentacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_movimentacao (cod_mov, cod_produto, chr_tipo, dat_mov, int_qtd, vch_motivo) FROM stdin;
1	1	E	2025-01-02 00:00:00	21	Compra inicial
2	1	S	2025-08-02 00:00:00	7	Venda
3	1	S	2026-05-02 00:00:00	5	Venda
4	2	E	2025-01-03 00:00:00	22	Compra inicial
5	2	S	2025-08-03 00:00:00	7	Venda
6	2	E	2026-02-03 00:00:00	12	Reposição
7	2	S	2026-05-03 00:00:00	5	Venda
8	3	E	2025-01-04 00:00:00	23	Compra inicial
9	3	S	2025-08-04 00:00:00	7	Venda
10	3	S	2026-05-04 00:00:00	5	Venda
11	4	E	2025-01-05 00:00:00	24	Compra inicial
12	4	S	2025-08-05 00:00:00	8	Venda
13	4	E	2026-02-05 00:00:00	14	Reposição
14	4	S	2026-05-05 00:00:00	6	Venda
15	5	E	2025-01-06 00:00:00	25	Compra inicial
16	5	S	2025-08-06 00:00:00	8	Venda
17	5	S	2026-05-06 00:00:00	6	Venda
18	6	E	2025-01-07 00:00:00	26	Compra inicial
19	6	S	2025-08-07 00:00:00	8	Venda
20	6	E	2026-02-07 00:00:00	16	Reposição
21	6	S	2026-05-07 00:00:00	6	Venda
22	7	E	2025-01-08 00:00:00	27	Compra inicial
23	7	S	2025-08-08 00:00:00	9	Venda
24	7	S	2026-05-08 00:00:00	6	Venda
25	8	E	2025-01-09 00:00:00	28	Compra inicial
26	8	S	2025-08-09 00:00:00	9	Venda
27	8	E	2026-02-09 00:00:00	18	Reposição
28	8	S	2026-05-09 00:00:00	7	Venda
29	9	E	2025-01-10 00:00:00	29	Compra inicial
30	9	S	2025-08-10 00:00:00	9	Venda
31	9	S	2026-05-10 00:00:00	7	Venda
32	10	E	2025-01-11 00:00:00	30	Compra inicial
33	10	S	2025-08-11 00:00:00	10	Venda
34	10	E	2026-02-11 00:00:00	10	Reposição
35	10	S	2026-05-11 00:00:00	7	Venda
36	11	E	2025-01-12 00:00:00	31	Compra inicial
37	11	S	2025-08-12 00:00:00	10	Venda
38	11	S	2026-05-12 00:00:00	7	Venda
39	12	E	2025-01-13 00:00:00	32	Compra inicial
40	12	S	2025-08-13 00:00:00	10	Venda
41	12	E	2026-02-13 00:00:00	12	Reposição
42	12	S	2026-05-13 00:00:00	8	Venda
43	13	E	2025-01-14 00:00:00	33	Compra inicial
44	13	S	2025-08-14 00:00:00	11	Venda
45	13	S	2026-05-14 00:00:00	8	Venda
46	14	E	2025-01-15 00:00:00	34	Compra inicial
47	14	S	2025-08-15 00:00:00	11	Venda
48	14	E	2026-02-15 00:00:00	14	Reposição
49	14	S	2026-05-15 00:00:00	8	Venda
50	15	E	2025-01-16 00:00:00	35	Compra inicial
51	15	S	2025-08-16 00:00:00	11	Venda
52	15	S	2026-05-16 00:00:00	8	Venda
53	16	E	2025-01-17 00:00:00	36	Compra inicial
54	16	S	2025-08-17 00:00:00	12	Venda
55	16	E	2026-02-17 00:00:00	16	Reposição
56	16	S	2026-05-17 00:00:00	9	Venda
57	17	E	2025-01-18 00:00:00	37	Compra inicial
58	17	S	2025-08-18 00:00:00	12	Venda
59	17	S	2026-05-18 00:00:00	9	Venda
60	18	E	2025-01-19 00:00:00	38	Compra inicial
61	18	S	2025-08-19 00:00:00	12	Venda
62	18	E	2026-02-19 00:00:00	18	Reposição
63	18	S	2026-05-19 00:00:00	9	Venda
64	19	E	2025-01-20 00:00:00	39	Compra inicial
65	19	S	2025-08-20 00:00:00	13	Venda
66	19	S	2026-05-20 00:00:00	9	Venda
67	20	E	2025-01-21 00:00:00	40	Compra inicial
68	20	S	2025-08-21 00:00:00	13	Venda
69	20	E	2026-02-21 00:00:00	10	Reposição
70	20	S	2026-05-21 00:00:00	10	Venda
71	21	E	2025-01-22 00:00:00	41	Compra inicial
72	21	S	2025-08-22 00:00:00	13	Venda
73	21	S	2026-05-22 00:00:00	10	Venda
74	22	E	2025-01-23 00:00:00	42	Compra inicial
75	22	S	2025-08-23 00:00:00	14	Venda
76	22	E	2026-02-23 00:00:00	12	Reposição
77	22	S	2026-05-23 00:00:00	10	Venda
78	23	E	2025-01-24 00:00:00	43	Compra inicial
79	23	S	2025-08-24 00:00:00	14	Venda
80	23	S	2026-05-24 00:00:00	10	Venda
81	24	E	2025-01-25 00:00:00	44	Compra inicial
82	24	S	2025-08-25 00:00:00	14	Venda
83	24	E	2026-02-25 00:00:00	14	Reposição
84	24	S	2026-05-25 00:00:00	11	Venda
85	25	E	2025-01-26 00:00:00	45	Compra inicial
86	25	S	2025-08-26 00:00:00	15	Venda
87	25	S	2026-05-26 00:00:00	11	Venda
88	26	E	2025-01-27 00:00:00	46	Compra inicial
89	26	S	2025-08-27 00:00:00	15	Venda
90	26	E	2026-02-27 00:00:00	16	Reposição
91	26	S	2026-05-27 00:00:00	11	Venda
92	27	E	2025-01-28 00:00:00	47	Compra inicial
93	27	S	2025-08-28 00:00:00	15	Venda
94	27	S	2026-05-28 00:00:00	11	Venda
95	28	E	2025-01-01 00:00:00	48	Compra inicial
96	28	S	2025-08-01 00:00:00	16	Venda
97	28	E	2026-02-01 00:00:00	18	Reposição
98	28	S	2026-05-01 00:00:00	12	Venda
99	29	E	2025-01-02 00:00:00	49	Compra inicial
100	29	S	2025-08-02 00:00:00	16	Venda
101	29	S	2026-05-02 00:00:00	12	Venda
102	30	E	2025-01-03 00:00:00	20	Compra inicial
103	30	S	2025-08-03 00:00:00	6	Venda
104	30	E	2026-02-03 00:00:00	10	Reposição
105	30	S	2026-05-03 00:00:00	5	Venda
106	31	E	2025-01-04 00:00:00	21	Compra inicial
107	31	S	2025-08-04 00:00:00	7	Venda
108	31	S	2026-05-04 00:00:00	5	Venda
109	32	E	2025-01-05 00:00:00	22	Compra inicial
110	32	S	2025-08-05 00:00:00	7	Venda
111	32	E	2026-02-05 00:00:00	12	Reposição
112	32	S	2026-05-05 00:00:00	5	Venda
113	33	E	2025-01-06 00:00:00	23	Compra inicial
114	33	S	2025-08-06 00:00:00	7	Venda
115	33	S	2026-05-06 00:00:00	5	Venda
116	34	E	2025-01-07 00:00:00	24	Compra inicial
117	34	S	2025-08-07 00:00:00	8	Venda
118	34	E	2026-02-07 00:00:00	14	Reposição
119	34	S	2026-05-07 00:00:00	6	Venda
120	35	E	2025-01-08 00:00:00	25	Compra inicial
121	35	S	2025-08-08 00:00:00	8	Venda
122	35	S	2026-05-08 00:00:00	6	Venda
123	36	E	2025-01-09 00:00:00	26	Compra inicial
124	36	S	2025-08-09 00:00:00	8	Venda
125	36	E	2026-02-09 00:00:00	16	Reposição
126	36	S	2026-05-09 00:00:00	6	Venda
127	37	E	2025-01-10 00:00:00	27	Compra inicial
128	37	S	2025-08-10 00:00:00	9	Venda
129	37	S	2026-05-10 00:00:00	6	Venda
130	38	E	2025-01-11 00:00:00	28	Compra inicial
131	38	S	2025-08-11 00:00:00	9	Venda
132	38	E	2026-02-11 00:00:00	18	Reposição
133	38	S	2026-05-11 00:00:00	7	Venda
134	39	E	2025-01-12 00:00:00	29	Compra inicial
135	39	S	2025-08-12 00:00:00	9	Venda
136	39	S	2026-05-12 00:00:00	7	Venda
137	40	E	2025-01-13 00:00:00	30	Compra inicial
138	40	S	2025-08-13 00:00:00	10	Venda
139	40	E	2026-02-13 00:00:00	10	Reposição
140	40	S	2026-05-13 00:00:00	7	Venda
141	41	E	2025-01-14 00:00:00	31	Compra inicial
142	41	S	2025-08-14 00:00:00	10	Venda
143	41	S	2026-05-14 00:00:00	7	Venda
144	42	E	2025-01-15 00:00:00	32	Compra inicial
145	42	S	2025-08-15 00:00:00	10	Venda
146	42	E	2026-02-15 00:00:00	12	Reposição
147	42	S	2026-05-15 00:00:00	8	Venda
148	43	E	2025-01-16 00:00:00	33	Compra inicial
149	43	S	2025-08-16 00:00:00	11	Venda
150	43	S	2026-05-16 00:00:00	8	Venda
151	44	E	2025-01-17 00:00:00	34	Compra inicial
152	44	S	2025-08-17 00:00:00	11	Venda
153	44	E	2026-02-17 00:00:00	14	Reposição
154	44	S	2026-05-17 00:00:00	8	Venda
155	45	E	2025-01-18 00:00:00	35	Compra inicial
156	45	S	2025-08-18 00:00:00	11	Venda
157	45	S	2026-05-18 00:00:00	8	Venda
158	46	E	2025-01-19 00:00:00	36	Compra inicial
159	46	S	2025-08-19 00:00:00	12	Venda
160	46	E	2026-02-19 00:00:00	16	Reposição
161	46	S	2026-05-19 00:00:00	9	Venda
162	47	E	2025-01-20 00:00:00	37	Compra inicial
163	47	S	2025-08-20 00:00:00	12	Venda
164	47	S	2026-05-20 00:00:00	9	Venda
165	48	E	2025-01-21 00:00:00	38	Compra inicial
166	48	S	2025-08-21 00:00:00	12	Venda
167	48	E	2026-02-21 00:00:00	18	Reposição
168	48	S	2026-05-21 00:00:00	9	Venda
169	49	E	2025-01-22 00:00:00	39	Compra inicial
170	49	S	2025-08-22 00:00:00	13	Venda
171	49	S	2026-05-22 00:00:00	9	Venda
172	50	E	2025-01-23 00:00:00	40	Compra inicial
173	50	S	2025-08-23 00:00:00	13	Venda
174	50	E	2026-02-23 00:00:00	10	Reposição
175	50	S	2026-05-23 00:00:00	10	Venda
176	51	E	2025-01-24 00:00:00	41	Compra inicial
177	51	S	2025-08-24 00:00:00	13	Venda
178	51	S	2026-05-24 00:00:00	10	Venda
179	52	E	2025-01-25 00:00:00	42	Compra inicial
180	52	S	2025-08-25 00:00:00	14	Venda
181	52	E	2026-02-25 00:00:00	12	Reposição
182	52	S	2026-05-25 00:00:00	10	Venda
183	53	E	2025-01-26 00:00:00	43	Compra inicial
184	53	S	2025-08-26 00:00:00	14	Venda
185	53	S	2026-05-26 00:00:00	10	Venda
186	54	E	2025-01-27 00:00:00	44	Compra inicial
187	54	S	2025-08-27 00:00:00	14	Venda
188	54	E	2026-02-27 00:00:00	14	Reposição
189	54	S	2026-05-27 00:00:00	11	Venda
190	55	E	2025-01-28 00:00:00	45	Compra inicial
191	55	S	2025-08-28 00:00:00	15	Venda
192	55	S	2026-05-28 00:00:00	11	Venda
193	56	E	2025-01-01 00:00:00	46	Compra inicial
194	56	S	2025-08-01 00:00:00	15	Venda
195	56	E	2026-02-01 00:00:00	16	Reposição
196	56	S	2026-05-01 00:00:00	11	Venda
197	57	E	2025-01-02 00:00:00	47	Compra inicial
198	57	S	2025-08-02 00:00:00	15	Venda
199	57	S	2026-05-02 00:00:00	11	Venda
200	58	E	2025-01-03 00:00:00	48	Compra inicial
201	58	S	2025-08-03 00:00:00	16	Venda
202	58	E	2026-02-03 00:00:00	18	Reposição
203	58	S	2026-05-03 00:00:00	12	Venda
204	59	E	2025-01-04 00:00:00	49	Compra inicial
205	59	S	2025-08-04 00:00:00	16	Venda
206	59	S	2026-05-04 00:00:00	12	Venda
207	60	E	2025-01-05 00:00:00	20	Compra inicial
208	60	S	2025-08-05 00:00:00	6	Venda
209	60	E	2026-02-05 00:00:00	10	Reposição
210	60	S	2026-05-05 00:00:00	5	Venda
211	61	E	2025-01-06 00:00:00	21	Compra inicial
212	61	S	2025-08-06 00:00:00	7	Venda
213	61	S	2026-05-06 00:00:00	5	Venda
214	62	E	2025-01-07 00:00:00	22	Compra inicial
215	62	S	2025-08-07 00:00:00	7	Venda
216	62	E	2026-02-07 00:00:00	12	Reposição
217	62	S	2026-05-07 00:00:00	5	Venda
218	63	E	2025-01-08 00:00:00	23	Compra inicial
219	63	S	2025-08-08 00:00:00	7	Venda
220	63	S	2026-05-08 00:00:00	5	Venda
221	64	E	2025-01-09 00:00:00	24	Compra inicial
222	64	S	2025-08-09 00:00:00	8	Venda
223	64	E	2026-02-09 00:00:00	14	Reposição
224	64	S	2026-05-09 00:00:00	6	Venda
225	65	E	2025-01-10 00:00:00	25	Compra inicial
226	65	S	2025-08-10 00:00:00	8	Venda
227	65	S	2026-05-10 00:00:00	6	Venda
228	66	E	2025-01-11 00:00:00	26	Compra inicial
229	66	S	2025-08-11 00:00:00	8	Venda
230	66	E	2026-02-11 00:00:00	16	Reposição
231	66	S	2026-05-11 00:00:00	6	Venda
232	67	E	2025-01-12 00:00:00	27	Compra inicial
233	67	S	2025-08-12 00:00:00	9	Venda
234	67	S	2026-05-12 00:00:00	6	Venda
235	68	E	2025-01-13 00:00:00	28	Compra inicial
236	68	S	2025-08-13 00:00:00	9	Venda
237	68	E	2026-02-13 00:00:00	18	Reposição
238	68	S	2026-05-13 00:00:00	7	Venda
239	69	E	2025-01-14 00:00:00	29	Compra inicial
240	69	S	2025-08-14 00:00:00	9	Venda
241	69	S	2026-05-14 00:00:00	7	Venda
242	70	E	2025-01-15 00:00:00	30	Compra inicial
243	70	S	2025-08-15 00:00:00	10	Venda
244	70	E	2026-02-15 00:00:00	10	Reposição
245	70	S	2026-05-15 00:00:00	7	Venda
246	71	E	2025-01-16 00:00:00	31	Compra inicial
247	71	S	2025-08-16 00:00:00	10	Venda
248	71	S	2026-05-16 00:00:00	7	Venda
249	72	E	2025-01-17 00:00:00	32	Compra inicial
250	72	S	2025-08-17 00:00:00	10	Venda
251	72	E	2026-02-17 00:00:00	12	Reposição
252	72	S	2026-05-17 00:00:00	8	Venda
253	73	E	2025-01-18 00:00:00	33	Compra inicial
254	73	S	2025-08-18 00:00:00	11	Venda
255	73	S	2026-05-18 00:00:00	8	Venda
256	74	E	2025-01-19 00:00:00	34	Compra inicial
257	74	S	2025-08-19 00:00:00	11	Venda
258	74	E	2026-02-19 00:00:00	14	Reposição
259	74	S	2026-05-19 00:00:00	8	Venda
260	75	E	2025-01-20 00:00:00	35	Compra inicial
261	75	S	2025-08-20 00:00:00	11	Venda
262	75	S	2026-05-20 00:00:00	8	Venda
263	76	E	2025-01-21 00:00:00	36	Compra inicial
264	76	S	2025-08-21 00:00:00	12	Venda
265	76	E	2026-02-21 00:00:00	16	Reposição
266	76	S	2026-05-21 00:00:00	9	Venda
267	77	E	2025-01-22 00:00:00	37	Compra inicial
268	77	S	2025-08-22 00:00:00	12	Venda
269	77	S	2026-05-22 00:00:00	9	Venda
270	78	E	2025-01-23 00:00:00	38	Compra inicial
271	78	S	2025-08-23 00:00:00	12	Venda
272	78	E	2026-02-23 00:00:00	18	Reposição
273	78	S	2026-05-23 00:00:00	9	Venda
274	79	E	2025-01-24 00:00:00	39	Compra inicial
275	79	S	2025-08-24 00:00:00	13	Venda
276	79	S	2026-05-24 00:00:00	9	Venda
277	80	E	2025-01-25 00:00:00	40	Compra inicial
278	80	S	2025-08-25 00:00:00	13	Venda
279	80	E	2026-02-25 00:00:00	10	Reposição
280	80	S	2026-05-25 00:00:00	10	Venda
281	81	E	2025-01-26 00:00:00	41	Compra inicial
282	81	S	2025-08-26 00:00:00	13	Venda
283	81	S	2026-05-26 00:00:00	10	Venda
284	82	E	2025-01-27 00:00:00	42	Compra inicial
285	82	S	2025-08-27 00:00:00	14	Venda
286	82	E	2026-02-27 00:00:00	12	Reposição
287	82	S	2026-05-27 00:00:00	10	Venda
288	83	E	2025-01-28 00:00:00	43	Compra inicial
289	83	S	2025-08-28 00:00:00	14	Venda
290	83	S	2026-05-28 00:00:00	10	Venda
291	84	E	2025-01-01 00:00:00	44	Compra inicial
292	84	S	2025-08-01 00:00:00	14	Venda
293	84	E	2026-02-01 00:00:00	14	Reposição
294	84	S	2026-05-01 00:00:00	11	Venda
295	85	E	2025-01-02 00:00:00	45	Compra inicial
296	85	S	2025-08-02 00:00:00	15	Venda
297	85	S	2026-05-02 00:00:00	11	Venda
298	86	E	2025-01-03 00:00:00	46	Compra inicial
299	86	S	2025-08-03 00:00:00	15	Venda
300	86	E	2026-02-03 00:00:00	16	Reposição
301	86	S	2026-05-03 00:00:00	11	Venda
302	87	E	2025-01-04 00:00:00	47	Compra inicial
303	87	S	2025-08-04 00:00:00	15	Venda
304	87	S	2026-05-04 00:00:00	11	Venda
305	88	E	2025-01-05 00:00:00	48	Compra inicial
306	88	S	2025-08-05 00:00:00	16	Venda
307	88	E	2026-02-05 00:00:00	18	Reposição
308	88	S	2026-05-05 00:00:00	12	Venda
309	89	E	2025-01-06 00:00:00	49	Compra inicial
310	89	S	2025-08-06 00:00:00	16	Venda
311	89	S	2026-05-06 00:00:00	12	Venda
312	90	E	2025-01-07 00:00:00	20	Compra inicial
313	90	S	2025-08-07 00:00:00	6	Venda
314	90	E	2026-02-07 00:00:00	10	Reposição
315	90	S	2026-05-07 00:00:00	5	Venda
316	91	E	2025-01-08 00:00:00	21	Compra inicial
317	91	S	2025-08-08 00:00:00	7	Venda
318	91	S	2026-05-08 00:00:00	5	Venda
319	92	E	2025-01-09 00:00:00	22	Compra inicial
320	92	S	2025-08-09 00:00:00	7	Venda
321	92	E	2026-02-09 00:00:00	12	Reposição
322	92	S	2026-05-09 00:00:00	5	Venda
323	93	E	2025-01-10 00:00:00	23	Compra inicial
324	93	S	2025-08-10 00:00:00	7	Venda
325	93	S	2026-05-10 00:00:00	5	Venda
326	94	E	2025-01-11 00:00:00	24	Compra inicial
327	94	S	2025-08-11 00:00:00	8	Venda
328	94	E	2026-02-11 00:00:00	14	Reposição
329	94	S	2026-05-11 00:00:00	6	Venda
330	95	E	2025-01-12 00:00:00	25	Compra inicial
331	95	S	2025-08-12 00:00:00	8	Venda
332	95	S	2026-05-12 00:00:00	6	Venda
333	96	E	2025-01-13 00:00:00	26	Compra inicial
334	96	S	2025-08-13 00:00:00	8	Venda
335	96	E	2026-02-13 00:00:00	16	Reposição
336	96	S	2026-05-13 00:00:00	6	Venda
337	97	E	2025-01-14 00:00:00	27	Compra inicial
338	97	S	2025-08-14 00:00:00	9	Venda
339	97	S	2026-05-14 00:00:00	6	Venda
340	98	E	2025-01-15 00:00:00	28	Compra inicial
341	98	S	2025-08-15 00:00:00	9	Venda
342	98	E	2026-02-15 00:00:00	18	Reposição
343	98	S	2026-05-15 00:00:00	7	Venda
344	99	E	2025-01-16 00:00:00	29	Compra inicial
345	99	S	2025-08-16 00:00:00	9	Venda
346	99	S	2026-05-16 00:00:00	7	Venda
347	100	E	2025-01-17 00:00:00	30	Compra inicial
348	100	S	2025-08-17 00:00:00	10	Venda
349	100	E	2026-02-17 00:00:00	10	Reposição
350	100	S	2026-05-17 00:00:00	7	Venda
\.


--
-- Data for Name: tb_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_produto (cod_produto, vch_nome, vch_marca, preco_custo, vch_categoria, preco_venda, imagem_url) FROM stdin;
1	Chronos Premium 50ml	Natura	25.30	Skincare	36.69	\N
2	Q10 Intense 51ml	Nivea	36.00	Skincare	52.20	\N
3	Revitalift Matte 52ml	Loréal Paris	46.70	Skincare	67.72	\N
4	Renew Glow 53ml	Avon	57.40	Skincare	83.23	\N
5	Pink Repair 54ml	Granado	68.10	Skincare	98.74	\N
6	Chronos Fresh 55ml	Natura	61.80	Skincare	89.61	\N
7	Q10 Soft 56ml	Nivea	72.50	Skincare	105.12	\N
8	Revitalift Expert 57ml	Loréal Paris	83.20	Skincare	120.64	\N
9	Renew Pro 58ml	Avon	93.90	Skincare	136.16	\N
10	Pink Classic 59ml	Granado	104.60	Skincare	151.67	\N
11	Chronos Premium 60ml	Natura	98.30	Skincare	142.53	\N
12	Q10 Intense 61ml	Nivea	109.00	Skincare	158.05	\N
13	Revitalift Matte 62ml	Loréal Paris	119.70	Skincare	173.56	\N
14	Renew Glow 63ml	Avon	130.40	Skincare	189.08	\N
15	Pink Repair 64ml	Granado	31.60	Skincare	45.82	\N
16	Chronos Fresh 65ml	Natura	25.30	Skincare	36.69	\N
17	Q10 Soft 66ml	Nivea	36.00	Skincare	52.20	\N
18	Glam Premium 50ml	Eudora	39.90	Maquiagem	57.85	\N
19	Base Intense 51ml	Vult	50.60	Maquiagem	73.37	\N
20	Ultra Matte 52ml	Dailus	61.30	Maquiagem	88.88	\N
21	Fit Me Glow 53ml	Maybelline	72.00	Maquiagem	104.40	\N
22	Feels Repair 54ml	Ruby Rose	82.70	Maquiagem	119.92	\N
23	Glam Fresh 55ml	Eudora	76.40	Maquiagem	110.78	\N
24	Base Soft 56ml	Vult	87.10	Maquiagem	126.29	\N
25	Ultra Expert 57ml	Dailus	97.80	Maquiagem	141.81	\N
26	Fit Me Pro 58ml	Maybelline	108.50	Maquiagem	157.32	\N
27	Feels Classic 59ml	Ruby Rose	119.20	Maquiagem	172.84	\N
28	Glam Premium 60ml	Eudora	112.90	Maquiagem	163.71	\N
29	Base Intense 61ml	Vult	123.60	Maquiagem	179.22	\N
30	Ultra Matte 62ml	Dailus	24.80	Maquiagem	35.96	\N
31	Fit Me Glow 63ml	Maybelline	35.50	Maquiagem	51.48	\N
32	Feels Repair 64ml	Ruby Rose	46.20	Maquiagem	66.99	\N
33	Glam Fresh 65ml	Eudora	39.90	Maquiagem	57.85	\N
34	Base Soft 66ml	Vult	50.60	Maquiagem	73.37	\N
35	Floratta Premium 50ml	O Boticário	54.50	Perfumaria	79.02	\N
36	Kaiak Intense 51ml	Natura	65.20	Perfumaria	94.54	\N
37	Impression Matte 52ml	Eudora	75.90	Perfumaria	110.06	\N
38	Far Away Glow 53ml	Avon	86.60	Perfumaria	125.57	\N
39	Malbec Repair 54ml	O Boticário	97.30	Perfumaria	141.08	\N
40	Floratta Fresh 55ml	O Boticário	91.00	Perfumaria	131.95	\N
41	Kaiak Soft 56ml	Natura	101.70	Perfumaria	147.47	\N
42	Impression Expert 57ml	Eudora	112.40	Perfumaria	162.98	\N
43	Far Away Pro 58ml	Avon	123.10	Perfumaria	178.49	\N
44	Malbec Classic 59ml	O Boticário	133.80	Perfumaria	194.01	\N
45	Floratta Premium 60ml	O Boticário	18.00	Perfumaria	26.10	\N
46	Kaiak Intense 61ml	Natura	28.70	Perfumaria	41.61	\N
47	Impression Matte 62ml	Eudora	39.40	Perfumaria	57.13	\N
48	Far Away Glow 63ml	Avon	50.10	Perfumaria	72.64	\N
49	Malbec Repair 64ml	O Boticário	60.80	Perfumaria	88.16	\N
50	Floratta Fresh 65ml	O Boticário	54.50	Perfumaria	79.02	\N
51	Kaiak Soft 66ml	Natura	65.20	Perfumaria	94.54	\N
52	Reparação Total Premium 50ml	Elseve	69.10	Cabelos	100.19	\N
53	Pro-V Intense 51ml	Pantene	79.80	Cabelos	115.71	\N
54	Ceramidas Matte 52ml	Seda	90.50	Cabelos	131.22	\N
55	Meu Liso Glow 53ml	Salon Line	101.20	Cabelos	146.74	\N
56	Morte Súbita Repair 54ml	Lola Cosmetics	111.90	Cabelos	162.25	\N
57	Reparação Total Fresh 55ml	Elseve	105.60	Cabelos	153.12	\N
58	Pro-V Soft 56ml	Pantene	116.30	Cabelos	168.63	\N
59	Ceramidas Expert 57ml	Seda	127.00	Cabelos	184.15	\N
60	Meu Liso Pro 58ml	Salon Line	28.20	Cabelos	40.89	\N
61	Morte Súbita Classic 59ml	Lola Cosmetics	38.90	Cabelos	56.40	\N
62	Reparação Total Premium 60ml	Elseve	32.60	Cabelos	47.27	\N
63	Pro-V Intense 61ml	Pantene	43.30	Cabelos	62.78	\N
64	Ceramidas Matte 62ml	Seda	54.00	Cabelos	78.30	\N
65	Meu Liso Glow 63ml	Salon Line	64.70	Cabelos	93.81	\N
66	Morte Súbita Repair 64ml	Lola Cosmetics	75.40	Cabelos	109.33	\N
67	Reparação Total Fresh 65ml	Elseve	69.10	Cabelos	100.19	\N
68	Pro-V Soft 66ml	Pantene	79.80	Cabelos	115.71	\N
69	Esmalte Premium 50ml	Risqué	83.70	Unhas	121.36	\N
70	Cremoso Intense 51ml	Colorama	94.40	Unhas	136.88	\N
71	Gel Plus Matte 52ml	Impala	105.10	Unhas	152.39	\N
72	Nude Glow 53ml	Dailus	115.80	Unhas	167.91	\N
73	5Free Repair 54ml	Vult	126.50	Unhas	183.42	\N
74	Esmalte Fresh 55ml	Risqué	120.20	Unhas	174.29	\N
75	Cremoso Soft 56ml	Colorama	21.40	Unhas	31.03	\N
76	Gel Plus Expert 57ml	Impala	32.10	Unhas	46.55	\N
77	Nude Pro 58ml	Dailus	42.80	Unhas	62.06	\N
78	5Free Classic 59ml	Vult	53.50	Unhas	77.58	\N
79	Esmalte Premium 60ml	Risqué	47.20	Unhas	68.44	\N
80	Cremoso Intense 61ml	Colorama	57.90	Unhas	83.95	\N
81	Gel Plus Matte 62ml	Impala	68.60	Unhas	99.47	\N
82	Nude Glow 63ml	Dailus	79.30	Unhas	114.98	\N
83	5Free Repair 64ml	Vult	90.00	Unhas	130.50	\N
84	Esmalte Fresh 65ml	Risqué	83.70	Unhas	121.36	\N
85	Cremoso Soft 66ml	Colorama	94.40	Unhas	136.88	\N
86	Hidratante Premium 50ml	Dove	98.30	Corpo	142.53	\N
87	Milk Intense 51ml	Nivea	109.00	Corpo	158.05	\N
88	Body Care Matte 52ml	Johnsons	119.70	Corpo	173.56	\N
89	Terrapeutics Glow 53ml	Granado	130.40	Corpo	189.08	\N
90	Tododia Repair 54ml	Natura	31.60	Corpo	45.82	\N
91	Hidratante Fresh 55ml	Dove	25.30	Corpo	36.69	\N
92	Milk Soft 56ml	Nivea	36.00	Corpo	52.20	\N
93	Body Care Expert 57ml	Johnsons	46.70	Corpo	67.72	\N
94	Terrapeutics Pro 58ml	Granado	57.40	Corpo	83.23	\N
95	Tododia Classic 59ml	Natura	68.10	Corpo	98.74	\N
96	Hidratante Premium 60ml	Dove	61.80	Corpo	89.61	\N
97	Milk Intense 61ml	Nivea	72.50	Corpo	105.12	\N
98	Body Care Matte 62ml	Johnsons	83.20	Corpo	120.64	\N
99	Terrapeutics Glow 63ml	Granado	93.90	Corpo	136.16	\N
100	Tododia Repair 64ml	Natura	104.60	Corpo	151.67	\N
\.


--
-- Data for Name: tb_usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tb_usuario (cod_usuario, vch_email, vch_senha) FROM stdin;
1	erica.sna@email.com	senha_criptografada_123
2	teste-email@email.com	senha_123
3	teste@example.com	senha123
4	test@email.com	senha123
5	test22@email.com	senha123
6	testuser_1780357197@test.com	senha123
\.


--
-- Name: tb_lote_cod_lote_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_lote_cod_lote_seq', 125, true);


--
-- Name: tb_movimentacao_cod_mov_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_movimentacao_cod_mov_seq', 350, true);


--
-- Name: tb_produto_cod_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_produto_cod_produto_seq', 100, true);


--
-- Name: tb_usuario_cod_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tb_usuario_cod_usuario_seq', 2, true);


--
-- Name: tb_lote tb_lote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_lote
    ADD CONSTRAINT tb_lote_pkey PRIMARY KEY (cod_lote);


--
-- Name: tb_movimentacao tb_movimentacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_movimentacao
    ADD CONSTRAINT tb_movimentacao_pkey PRIMARY KEY (cod_mov);


--
-- Name: tb_produto tb_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_produto
    ADD CONSTRAINT tb_produto_pkey PRIMARY KEY (cod_produto);


--
-- Name: tb_usuario tb_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT tb_usuario_pkey PRIMARY KEY (cod_usuario);


--
-- Name: tb_usuario tb_usuario_vch_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_usuario
    ADD CONSTRAINT tb_usuario_vch_email_key UNIQUE (vch_email);


--
-- Name: idx_lote_validade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lote_validade ON public.tb_lote USING btree (dat_validade);


--
-- Name: idx_produto_categoria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto_categoria ON public.tb_produto USING btree (vch_categoria);


--
-- Name: idx_produto_marca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto_marca ON public.tb_produto USING btree (vch_marca);


--
-- Name: idx_produto_preco_custo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto_preco_custo ON public.tb_produto USING btree (preco_custo);


--
-- Name: idx_produto_preco_venda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produto_preco_venda ON public.tb_produto USING btree (preco_venda);


--
-- Name: tb_lote tb_lote_cod_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_lote
    ADD CONSTRAINT tb_lote_cod_produto_fkey FOREIGN KEY (cod_produto) REFERENCES public.tb_produto(cod_produto) ON DELETE RESTRICT;


--
-- Name: tb_movimentacao tb_movimentacao_cod_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tb_movimentacao
    ADD CONSTRAINT tb_movimentacao_cod_produto_fkey FOREIGN KEY (cod_produto) REFERENCES public.tb_produto(cod_produto);


--
-- PostgreSQL database dump complete
--

\unrestrict 8v8khu7uGx1ED1GoyejQD7UOvuX75z2abuo4GJ60V5XhGluE0dfDgwYrV7H7ORG

