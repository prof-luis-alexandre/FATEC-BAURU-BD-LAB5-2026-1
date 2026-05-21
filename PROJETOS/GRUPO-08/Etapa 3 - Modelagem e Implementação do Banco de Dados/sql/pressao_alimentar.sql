--
-- PostgreSQL database dump
--

\restrict mOrAs3LCGMoCFH0IjYh3uLigKZdgf8Ed1ldiEoxMxZmBKojF5IghEhJEpVgYluq

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-19 10:29:19

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
-- TOC entry 220 (class 1259 OID 16391)
-- Name: fonte_dados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fonte_dados (
    id_fonte integer NOT NULL,
    nome_fonte character varying(100) NOT NULL,
    orgao_responsavel character varying(150),
    url_fonte text,
    metodo_acesso character varying(100),
    data_coleta date,
    observacao text
);


ALTER TABLE public.fonte_dados OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16390)
-- Name: fonte_dados_id_fonte_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fonte_dados_id_fonte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fonte_dados_id_fonte_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 219
-- Name: fonte_dados_id_fonte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fonte_dados_id_fonte_seq OWNED BY public.fonte_dados.id_fonte;


--
-- TOC entry 228 (class 1259 OID 16460)
-- Name: indicador_pressao_alimentar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.indicador_pressao_alimentar (
    id_indicador integer NOT NULL,
    id_periodo integer NOT NULL,
    ipca_alimentos_acumulado_trimestre_pct numeric(12,4) CONSTRAINT indicador_pressao_alimentar_ipca_alimentos_acumulado_t_not_null NOT NULL,
    rendimento_real_medio_reais numeric(12,4),
    rendimento_real_variacao_trimestral_pct numeric(12,4),
    indicador_pressao_alimentar numeric(12,4),
    classificacao_pressao character varying(50) NOT NULL,
    interpretacao text
);


ALTER TABLE public.indicador_pressao_alimentar OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16459)
-- Name: indicador_pressao_alimentar_id_indicador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.indicador_pressao_alimentar_id_indicador_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.indicador_pressao_alimentar_id_indicador_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 227
-- Name: indicador_pressao_alimentar_id_indicador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.indicador_pressao_alimentar_id_indicador_seq OWNED BY public.indicador_pressao_alimentar.id_indicador;


--
-- TOC entry 226 (class 1259 OID 16434)
-- Name: observacao_serie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observacao_serie (
    id_observacao integer NOT NULL,
    id_serie integer NOT NULL,
    id_periodo integer NOT NULL,
    valor numeric(12,4) NOT NULL,
    tipo_valor character varying(100) NOT NULL,
    observacao text
);


ALTER TABLE public.observacao_serie OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16433)
-- Name: observacao_serie_id_observacao_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.observacao_serie_id_observacao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.observacao_serie_id_observacao_seq OWNER TO postgres;

--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 225
-- Name: observacao_serie_id_observacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.observacao_serie_id_observacao_seq OWNED BY public.observacao_serie.id_observacao;


--
-- TOC entry 224 (class 1259 OID 16419)
-- Name: periodo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periodo (
    id_periodo integer NOT NULL,
    ano integer NOT NULL,
    trimestre integer NOT NULL,
    mes integer NOT NULL,
    data_inicio date NOT NULL,
    data_fim date,
    CONSTRAINT ck_trimestre CHECK (((trimestre >= 1) AND (trimestre <= 4)))
);


ALTER TABLE public.periodo OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16418)
-- Name: periodo_id_periodo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periodo_id_periodo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.periodo_id_periodo_seq OWNER TO postgres;

--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 223
-- Name: periodo_id_periodo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periodo_id_periodo_seq OWNED BY public.periodo.id_periodo;


--
-- TOC entry 222 (class 1259 OID 16402)
-- Name: serie_economica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serie_economica (
    id_serie integer NOT NULL,
    id_fonte integer NOT NULL,
    codigo_serie character varying(50),
    nome_serie character varying(200) NOT NULL,
    descricao text,
    unidade_medida character varying(100),
    periodicidade_original character varying(50),
    tema character varying(100)
);


ALTER TABLE public.serie_economica OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16401)
-- Name: serie_economica_id_serie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serie_economica_id_serie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serie_economica_id_serie_seq OWNER TO postgres;

--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 221
-- Name: serie_economica_id_serie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serie_economica_id_serie_seq OWNED BY public.serie_economica.id_serie;


--
-- TOC entry 229 (class 1259 OID 16479)
-- Name: staging_base_pressao_alimentar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staging_base_pressao_alimentar (
    data_referencia date,
    ano integer,
    trimestre integer,
    mes integer,
    ipca_alimentos_acumulado_trimestre_pct numeric(12,4),
    quantidade_meses_ipca_no_trimestre integer,
    rendimento_real_medio_reais numeric(12,4),
    rendimento_real_variacao_trimestral_pct numeric(12,4),
    indicador_pressao_alimentar numeric(12,4),
    classificacao_pressao character varying(50),
    quantidade_registros_agregados integer
);


ALTER TABLE public.staging_base_pressao_alimentar OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16482)
-- Name: vw_pressao_alimentar_trimestral; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_pressao_alimentar_trimestral AS
 SELECT p.ano,
    p.trimestre,
    p.mes,
    p.data_inicio,
    p.data_fim,
    i.ipca_alimentos_acumulado_trimestre_pct,
    i.rendimento_real_medio_reais,
    i.rendimento_real_variacao_trimestral_pct,
    i.indicador_pressao_alimentar,
    i.classificacao_pressao,
    i.interpretacao
   FROM (public.indicador_pressao_alimentar i
     JOIN public.periodo p ON ((p.id_periodo = i.id_periodo)));


ALTER VIEW public.vw_pressao_alimentar_trimestral OWNER TO postgres;

--
-- TOC entry 4783 (class 2604 OID 16394)
-- Name: fonte_dados id_fonte; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fonte_dados ALTER COLUMN id_fonte SET DEFAULT nextval('public.fonte_dados_id_fonte_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 16463)
-- Name: indicador_pressao_alimentar id_indicador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indicador_pressao_alimentar ALTER COLUMN id_indicador SET DEFAULT nextval('public.indicador_pressao_alimentar_id_indicador_seq'::regclass);


--
-- TOC entry 4786 (class 2604 OID 16437)
-- Name: observacao_serie id_observacao; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observacao_serie ALTER COLUMN id_observacao SET DEFAULT nextval('public.observacao_serie_id_observacao_seq'::regclass);


--
-- TOC entry 4785 (class 2604 OID 16422)
-- Name: periodo id_periodo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodo ALTER COLUMN id_periodo SET DEFAULT nextval('public.periodo_id_periodo_seq'::regclass);


--
-- TOC entry 4784 (class 2604 OID 16405)
-- Name: serie_economica id_serie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_economica ALTER COLUMN id_serie SET DEFAULT nextval('public.serie_economica_id_serie_seq'::regclass);


--
-- TOC entry 4958 (class 0 OID 16391)
-- Dependencies: 220
-- Data for Name: fonte_dados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fonte_dados (id_fonte, nome_fonte, orgao_responsavel, url_fonte, metodo_acesso, data_coleta, observacao) FROM stdin;
1	IPEAData	Instituto de Pesquisa Econômica Aplicada	https://www.ipeadata.gov.br/	API via Python/ipeadatapy	2026-05-19	Fonte pública usada para obtenção das séries de IPCA alimentos e rendimento real.
\.


--
-- TOC entry 4966 (class 0 OID 16460)
-- Dependencies: 228
-- Data for Name: indicador_pressao_alimentar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.indicador_pressao_alimentar (id_indicador, id_periodo, ipca_alimentos_acumulado_trimestre_pct, rendimento_real_medio_reais, rendimento_real_variacao_trimestral_pct, indicador_pressao_alimentar, classificacao_pressao, interpretacao) FROM stdin;
1	1	1.3043	2995.0000	\N	\N	sem_classificacao	Primeiro período da série, sem classificação por ausência de período anterior para cálculo da variação do rendimento.
2	2	1.9322	2811.0303	-6.1426	8.0747	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
3	3	3.0807	2830.0000	0.6748	2.4058	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
4	4	3.2130	2849.0606	0.6735	2.5395	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
5	5	4.6484	2961.9697	3.9630	0.6854	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
6	6	1.3135	2851.2188	-3.7391	5.0526	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
7	7	-0.1805	2909.2424	2.0350	-2.2155	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
8	8	2.5000	2941.1212	1.0958	1.4042	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
9	9	3.3517	3041.9091	3.4269	-0.0752	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
10	10	1.6649	2927.8485	-3.7496	5.4146	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
11	11	0.4779	2925.4848	-0.0807	0.5586	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
12	12	2.3269	2971.0000	1.5558	0.7710	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
13	13	3.4989	3038.8485	2.2837	1.2152	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
14	14	2.9981	2894.2727	-4.7576	7.7557	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
15	15	0.8815	2854.9394	-1.3590	2.2405	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
16	16	4.1533	2899.0625	1.5455	2.6078	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
17	17	4.6459	3096.3030	6.8036	-2.1577	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
18	18	2.6018	2822.3030	-8.8493	11.4511	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
19	19	1.3293	2842.0909	0.7011	0.6281	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
20	20	-0.1701	2911.8182	2.4534	-2.6235	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
21	21	0.2381	3155.5152	8.3692	-8.1312	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
22	22	-0.2732	2871.3333	-9.0059	8.7327	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
23	23	-1.9387	2907.0909	1.2453	-3.1840	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
24	24	0.1079	2971.2424	2.2067	-2.0989	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
25	25	0.4778	3179.1212	6.9964	-6.5185	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
26	26	2.4486	2906.0000	-8.5911	11.0397	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
27	27	-0.3601	2924.4242	0.6340	-0.9941	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
28	28	1.4266	3036.0645	3.8175	-2.3909	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
29	29	3.0801	3204.9091	5.5613	-2.4812	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
30	30	-0.1837	2901.8788	-9.4552	9.2715	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
31	31	-0.7686	2917.2424	0.5294	-1.2980	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
32	32	4.1764	3003.0000	2.9397	1.2367	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
33	33	1.6361	3181.1212	5.9314	-4.2954	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
34	34	2.4220	2859.7273	-10.1032	12.5252	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
35	35	3.0881	2937.8182	2.7307	0.3574	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
36	36	6.3377	3011.1818	2.4972	3.8404	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
37	37	1.4244	3102.4848	3.0321	-1.6077	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
38	38	1.2754	2868.3438	-7.5469	8.8223	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
39	39	3.0387	2813.0313	-1.9284	4.9671	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
40	40	1.9790	2786.9697	-0.9265	2.9055	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
41	41	4.8824	2985.7273	7.1317	-2.2493	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
42	42	3.3703	2813.0000	-5.7851	9.1554	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
43	43	1.0253	2917.7879	3.7251	-2.6999	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
44	44	1.9221	3054.3030	4.6787	-2.7566	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
45	45	0.8013	3206.5455	4.9845	-4.1832	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
46	46	0.2054	2973.3030	-7.2739	7.4793	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
47	47	-2.0068	3043.5455	2.3624	-4.3693	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
48	48	2.0624	3120.3333	2.5230	-0.4606	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
49	49	2.8855	3316.4545	6.2853	-3.3997	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
50	50	1.7702	3142.5455	-5.2438	7.0140	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
51	51	-0.9428	3162.5455	0.6364	-1.5792	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
52	52	3.8374	3266.9375	3.3009	0.5365	pressao_moderada	Período em que a variação acumulada dos alimentos ficou acima da variação do rendimento real, mas com diferença menor.
53	53	2.8562	3503.9063	7.2535	-4.3973	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
54	54	0.8096	3249.2727	-7.2671	8.0767	alta_pressao	Período em que a variação acumulada dos alimentos ficou significativamente acima da variação do rendimento real.
55	55	-0.9869	3325.3939	2.3427	-3.3296	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
56	56	0.2700	3466.2727	4.2365	-3.9665	sem_pressao	Período em que a variação do rendimento acompanhou ou superou a variação acumulada dos alimentos.
\.


--
-- TOC entry 4964 (class 0 OID 16434)
-- Dependencies: 226
-- Data for Name: observacao_serie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.observacao_serie (id_observacao, id_serie, id_periodo, valor, tipo_valor, observacao) FROM stdin;
1	1	1	1.3043	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
2	1	2	1.9322	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
3	1	3	3.0807	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
4	1	4	3.2130	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
5	1	5	4.6484	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
6	1	6	1.3135	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
7	1	7	-0.1805	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
8	1	8	2.5000	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
9	1	9	3.3517	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
10	1	10	1.6649	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
11	1	11	0.4779	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
12	1	12	2.3269	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
13	1	13	3.4989	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
14	1	14	2.9981	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
15	1	15	0.8815	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
16	1	16	4.1533	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
17	1	17	4.6459	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
18	1	18	2.6018	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
19	1	19	1.3293	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
20	1	20	-0.1701	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
21	1	21	0.2381	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
22	1	22	-0.2732	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
23	1	23	-1.9387	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
24	1	24	0.1079	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
25	1	25	0.4778	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
26	1	26	2.4486	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
27	1	27	-0.3601	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
28	1	28	1.4266	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
29	1	29	3.0801	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
30	1	30	-0.1837	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
31	1	31	-0.7686	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
32	1	32	4.1764	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
33	1	33	1.6361	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
34	1	34	2.4220	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
35	1	35	3.0881	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
36	1	36	6.3377	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
37	1	37	1.4244	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
38	1	38	1.2754	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
39	1	39	3.0387	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
40	1	40	1.9790	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
41	1	41	4.8824	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
42	1	42	3.3703	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
43	1	43	1.0253	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
44	1	44	1.9221	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
45	1	45	0.8013	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
46	1	46	0.2054	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
47	1	47	-2.0068	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
48	1	48	2.0624	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
49	1	49	2.8855	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
50	1	50	1.7702	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
51	1	51	-0.9428	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
52	1	52	3.8374	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
53	1	53	2.8562	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
54	1	54	0.8096	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
55	1	55	-0.9869	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
56	1	56	0.2700	acumulado_trimestral_pct	IPCA de alimentos acumulado no trimestre por composição das taxas mensais.
57	2	2	-6.1426	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
58	2	3	0.6748	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
59	2	4	0.6735	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
60	2	5	3.9630	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
61	2	6	-3.7391	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
62	2	7	2.0350	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
63	2	8	1.0958	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
64	2	9	3.4269	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
65	2	10	-3.7496	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
66	2	11	-0.0807	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
67	2	12	1.5558	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
68	2	13	2.2837	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
69	2	14	-4.7576	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
70	2	15	-1.3590	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
71	2	16	1.5455	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
72	2	17	6.8036	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
73	2	18	-8.8493	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
74	2	19	0.7011	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
75	2	20	2.4534	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
76	2	21	8.3692	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
77	2	22	-9.0059	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
78	2	23	1.2453	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
79	2	24	2.2067	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
80	2	25	6.9964	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
81	2	26	-8.5911	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
82	2	27	0.6340	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
83	2	28	3.8175	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
84	2	29	5.5613	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
85	2	30	-9.4552	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
86	2	31	0.5294	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
87	2	32	2.9397	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
88	2	33	5.9314	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
89	2	34	-10.1032	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
90	2	35	2.7307	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
91	2	36	2.4972	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
92	2	37	3.0321	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
93	2	38	-7.5469	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
94	2	39	-1.9284	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
95	2	40	-0.9265	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
96	2	41	7.1317	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
97	2	42	-5.7851	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
98	2	43	3.7251	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
99	2	44	4.6787	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
100	2	45	4.9845	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
101	2	46	-7.2739	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
102	2	47	2.3624	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
103	2	48	2.5230	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
104	2	49	6.2853	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
105	2	50	-5.2438	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
106	2	51	0.6364	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
107	2	52	3.3009	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
108	2	53	7.2535	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
109	2	54	-7.2671	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
110	2	55	2.3427	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
111	2	56	4.2365	variacao_trimestral_pct	Variação percentual do rendimento real em relação ao trimestre anterior.
\.


--
-- TOC entry 4962 (class 0 OID 16419)
-- Dependencies: 224
-- Data for Name: periodo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periodo (id_periodo, ano, trimestre, mes, data_inicio, data_fim) FROM stdin;
1	2012	1	1	2012-01-01	2012-03-31
2	2012	2	4	2012-04-01	2012-06-30
3	2012	3	7	2012-07-01	2012-09-30
4	2012	4	10	2012-10-01	2012-12-31
5	2013	1	1	2013-01-01	2013-03-31
6	2013	2	4	2013-04-01	2013-06-30
7	2013	3	7	2013-07-01	2013-09-30
8	2013	4	10	2013-10-01	2013-12-31
9	2014	1	1	2014-01-01	2014-03-31
10	2014	2	4	2014-04-01	2014-06-30
11	2014	3	7	2014-07-01	2014-09-30
12	2014	4	10	2014-10-01	2014-12-31
13	2015	1	1	2015-01-01	2015-03-31
14	2015	2	4	2015-04-01	2015-06-30
15	2015	3	7	2015-07-01	2015-09-30
16	2015	4	10	2015-10-01	2015-12-31
17	2016	1	1	2016-01-01	2016-03-31
18	2016	2	4	2016-04-01	2016-06-30
19	2016	3	7	2016-07-01	2016-09-30
20	2016	4	10	2016-10-01	2016-12-31
21	2017	1	1	2017-01-01	2017-03-31
22	2017	2	4	2017-04-01	2017-06-30
23	2017	3	7	2017-07-01	2017-09-30
24	2017	4	10	2017-10-01	2017-12-31
25	2018	1	1	2018-01-01	2018-03-31
26	2018	2	4	2018-04-01	2018-06-30
27	2018	3	7	2018-07-01	2018-09-30
28	2018	4	10	2018-10-01	2018-12-31
29	2019	1	1	2019-01-01	2019-03-31
30	2019	2	4	2019-04-01	2019-06-30
31	2019	3	7	2019-07-01	2019-09-30
32	2019	4	10	2019-10-01	2019-12-31
33	2020	1	1	2020-01-01	2020-03-31
34	2020	2	4	2020-04-01	2020-06-30
35	2020	3	7	2020-07-01	2020-09-30
36	2020	4	10	2020-10-01	2020-12-31
37	2021	1	1	2021-01-01	2021-03-31
38	2021	2	4	2021-04-01	2021-06-30
39	2021	3	7	2021-07-01	2021-09-30
40	2021	4	10	2021-10-01	2021-12-31
41	2022	1	1	2022-01-01	2022-03-31
42	2022	2	4	2022-04-01	2022-06-30
43	2022	3	7	2022-07-01	2022-09-30
44	2022	4	10	2022-10-01	2022-12-31
45	2023	1	1	2023-01-01	2023-03-31
46	2023	2	4	2023-04-01	2023-06-30
47	2023	3	7	2023-07-01	2023-09-30
48	2023	4	10	2023-10-01	2023-12-31
49	2024	1	1	2024-01-01	2024-03-31
50	2024	2	4	2024-04-01	2024-06-30
51	2024	3	7	2024-07-01	2024-09-30
52	2024	4	10	2024-10-01	2024-12-31
53	2025	1	1	2025-01-01	2025-03-31
54	2025	2	4	2025-04-01	2025-06-30
55	2025	3	7	2025-07-01	2025-09-30
56	2025	4	10	2025-10-01	2025-12-31
\.


--
-- TOC entry 4960 (class 0 OID 16402)
-- Dependencies: 222
-- Data for Name: serie_economica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serie_economica (id_serie, id_fonte, codigo_serie, nome_serie, descricao, unidade_medida, periodicidade_original, tema) FROM stdin;
1	1	PRECOS12_IPCAAB12	IPCA - alimentos e bebidas	Taxa de variação do grupo alimentos e bebidas do IPCA, convertida para acumulado trimestral na base consolidada.	Percentual	Mensal	Inflação
2	1	PNADCT_RRETUF	Rendimento médio real	Rendimento médio real de todos os trabalhos efetivo, tratado e utilizado em variação trimestral.	Reais / percentual	Trimestral	Renda
\.


--
-- TOC entry 4967 (class 0 OID 16479)
-- Dependencies: 229
-- Data for Name: staging_base_pressao_alimentar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staging_base_pressao_alimentar (data_referencia, ano, trimestre, mes, ipca_alimentos_acumulado_trimestre_pct, quantidade_meses_ipca_no_trimestre, rendimento_real_medio_reais, rendimento_real_variacao_trimestral_pct, indicador_pressao_alimentar, classificacao_pressao, quantidade_registros_agregados) FROM stdin;
2012-01-01	2012	1	1	1.3043	3	2995.0000	\N	\N	sem_classificacao	33
2012-04-01	2012	2	4	1.9322	3	2811.0303	-6.1426	8.0747	alta_pressao	33
2012-07-01	2012	3	7	3.0807	3	2830.0000	0.6748	2.4058	alta_pressao	32
2012-10-01	2012	4	10	3.2130	3	2849.0606	0.6735	2.5395	alta_pressao	33
2013-01-01	2013	1	1	4.6484	3	2961.9697	3.9630	0.6854	pressao_moderada	33
2013-04-01	2013	2	4	1.3135	3	2851.2188	-3.7391	5.0526	alta_pressao	32
2013-07-01	2013	3	7	-0.1805	3	2909.2424	2.0350	-2.2155	sem_pressao	33
2013-10-01	2013	4	10	2.5000	3	2941.1212	1.0958	1.4042	alta_pressao	33
2014-01-01	2014	1	1	3.3517	3	3041.9091	3.4269	-0.0752	sem_pressao	33
2014-04-01	2014	2	4	1.6649	3	2927.8485	-3.7496	5.4146	alta_pressao	33
2014-07-01	2014	3	7	0.4779	3	2925.4848	-0.0807	0.5586	pressao_moderada	33
2014-10-01	2014	4	10	2.3269	3	2971.0000	1.5558	0.7710	pressao_moderada	32
2015-01-01	2015	1	1	3.4989	3	3038.8485	2.2837	1.2152	alta_pressao	33
2015-04-01	2015	2	4	2.9981	3	2894.2727	-4.7576	7.7557	alta_pressao	33
2015-07-01	2015	3	7	0.8815	3	2854.9394	-1.3590	2.2405	alta_pressao	33
2015-10-01	2015	4	10	4.1533	3	2899.0625	1.5455	2.6078	alta_pressao	32
2016-01-01	2016	1	1	4.6459	3	3096.3030	6.8036	-2.1577	sem_pressao	33
2016-04-01	2016	2	4	2.6018	3	2822.3030	-8.8493	11.4511	alta_pressao	33
2016-07-01	2016	3	7	1.3293	3	2842.0909	0.7011	0.6281	pressao_moderada	33
2016-10-01	2016	4	10	-0.1701	3	2911.8182	2.4534	-2.6235	sem_pressao	33
2017-01-01	2017	1	1	0.2381	3	3155.5152	8.3692	-8.1312	sem_pressao	33
2017-04-01	2017	2	4	-0.2732	3	2871.3333	-9.0059	8.7327	alta_pressao	33
2017-07-01	2017	3	7	-1.9387	3	2907.0909	1.2453	-3.1840	sem_pressao	33
2017-10-01	2017	4	10	0.1079	3	2971.2424	2.2067	-2.0989	sem_pressao	33
2018-01-01	2018	1	1	0.4778	3	3179.1212	6.9964	-6.5185	sem_pressao	33
2018-04-01	2018	2	4	2.4486	3	2906.0000	-8.5911	11.0397	alta_pressao	33
2018-07-01	2018	3	7	-0.3601	3	2924.4242	0.6340	-0.9941	sem_pressao	33
2018-10-01	2018	4	10	1.4266	3	3036.0645	3.8175	-2.3909	sem_pressao	31
2019-01-01	2019	1	1	3.0801	3	3204.9091	5.5613	-2.4812	sem_pressao	33
2019-04-01	2019	2	4	-0.1837	3	2901.8788	-9.4552	9.2715	alta_pressao	33
2019-07-01	2019	3	7	-0.7686	3	2917.2424	0.5294	-1.2980	sem_pressao	33
2019-10-01	2019	4	10	4.1764	3	3003.0000	2.9397	1.2367	alta_pressao	33
2020-01-01	2020	1	1	1.6361	3	3181.1212	5.9314	-4.2954	sem_pressao	33
2020-04-01	2020	2	4	2.4220	3	2859.7273	-10.1032	12.5252	alta_pressao	33
2020-07-01	2020	3	7	3.0881	3	2937.8182	2.7307	0.3574	pressao_moderada	33
2020-10-01	2020	4	10	6.3377	3	3011.1818	2.4972	3.8404	alta_pressao	33
2021-01-01	2021	1	1	1.4244	3	3102.4848	3.0321	-1.6077	sem_pressao	33
2021-04-01	2021	2	4	1.2754	3	2868.3438	-7.5469	8.8223	alta_pressao	32
2021-07-01	2021	3	7	3.0387	3	2813.0313	-1.9284	4.9671	alta_pressao	32
2021-10-01	2021	4	10	1.9790	3	2786.9697	-0.9265	2.9055	alta_pressao	33
2022-01-01	2022	1	1	4.8824	3	2985.7273	7.1317	-2.2493	sem_pressao	33
2022-04-01	2022	2	4	3.3703	3	2813.0000	-5.7851	9.1554	alta_pressao	33
2022-07-01	2022	3	7	1.0253	3	2917.7879	3.7251	-2.6999	sem_pressao	33
2022-10-01	2022	4	10	1.9221	3	3054.3030	4.6787	-2.7566	sem_pressao	33
2023-01-01	2023	1	1	0.8013	3	3206.5455	4.9845	-4.1832	sem_pressao	33
2023-04-01	2023	2	4	0.2054	3	2973.3030	-7.2739	7.4793	alta_pressao	33
2023-07-01	2023	3	7	-2.0068	3	3043.5455	2.3624	-4.3693	sem_pressao	33
2023-10-01	2023	4	10	2.0624	3	3120.3333	2.5230	-0.4606	sem_pressao	33
2024-01-01	2024	1	1	2.8855	3	3316.4545	6.2853	-3.3997	sem_pressao	33
2024-04-01	2024	2	4	1.7702	3	3142.5455	-5.2438	7.0140	alta_pressao	33
2024-07-01	2024	3	7	-0.9428	3	3162.5455	0.6364	-1.5792	sem_pressao	33
2024-10-01	2024	4	10	3.8374	3	3266.9375	3.3009	0.5365	pressao_moderada	32
2025-01-01	2025	1	1	2.8562	3	3503.9063	7.2535	-4.3973	sem_pressao	32
2025-04-01	2025	2	4	0.8096	3	3249.2727	-7.2671	8.0767	alta_pressao	33
2025-07-01	2025	3	7	-0.9869	3	3325.3939	2.3427	-3.3296	sem_pressao	33
2025-10-01	2025	4	10	0.2700	3	3466.2727	4.2365	-3.9665	sem_pressao	33
\.


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 219
-- Name: fonte_dados_id_fonte_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fonte_dados_id_fonte_seq', 1, true);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 227
-- Name: indicador_pressao_alimentar_id_indicador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.indicador_pressao_alimentar_id_indicador_seq', 56, true);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 225
-- Name: observacao_serie_id_observacao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.observacao_serie_id_observacao_seq', 111, true);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 223
-- Name: periodo_id_periodo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periodo_id_periodo_seq', 56, true);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 221
-- Name: serie_economica_id_serie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serie_economica_id_serie_seq', 2, true);


--
-- TOC entry 4790 (class 2606 OID 16400)
-- Name: fonte_dados fonte_dados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fonte_dados
    ADD CONSTRAINT fonte_dados_pkey PRIMARY KEY (id_fonte);


--
-- TOC entry 4802 (class 2606 OID 16473)
-- Name: indicador_pressao_alimentar indicador_pressao_alimentar_id_periodo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indicador_pressao_alimentar
    ADD CONSTRAINT indicador_pressao_alimentar_id_periodo_key UNIQUE (id_periodo);


--
-- TOC entry 4804 (class 2606 OID 16471)
-- Name: indicador_pressao_alimentar indicador_pressao_alimentar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indicador_pressao_alimentar
    ADD CONSTRAINT indicador_pressao_alimentar_pkey PRIMARY KEY (id_indicador);


--
-- TOC entry 4798 (class 2606 OID 16446)
-- Name: observacao_serie observacao_serie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observacao_serie
    ADD CONSTRAINT observacao_serie_pkey PRIMARY KEY (id_observacao);


--
-- TOC entry 4794 (class 2606 OID 16430)
-- Name: periodo periodo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodo
    ADD CONSTRAINT periodo_pkey PRIMARY KEY (id_periodo);


--
-- TOC entry 4792 (class 2606 OID 16412)
-- Name: serie_economica serie_economica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_economica
    ADD CONSTRAINT serie_economica_pkey PRIMARY KEY (id_serie);


--
-- TOC entry 4800 (class 2606 OID 16448)
-- Name: observacao_serie uq_observacao_serie; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observacao_serie
    ADD CONSTRAINT uq_observacao_serie UNIQUE (id_serie, id_periodo, tipo_valor);


--
-- TOC entry 4796 (class 2606 OID 16432)
-- Name: periodo uq_periodo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodo
    ADD CONSTRAINT uq_periodo UNIQUE (ano, trimestre);


--
-- TOC entry 4808 (class 2606 OID 16474)
-- Name: indicador_pressao_alimentar indicador_pressao_alimentar_id_periodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.indicador_pressao_alimentar
    ADD CONSTRAINT indicador_pressao_alimentar_id_periodo_fkey FOREIGN KEY (id_periodo) REFERENCES public.periodo(id_periodo);


--
-- TOC entry 4806 (class 2606 OID 16454)
-- Name: observacao_serie observacao_serie_id_periodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observacao_serie
    ADD CONSTRAINT observacao_serie_id_periodo_fkey FOREIGN KEY (id_periodo) REFERENCES public.periodo(id_periodo);


--
-- TOC entry 4807 (class 2606 OID 16449)
-- Name: observacao_serie observacao_serie_id_serie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observacao_serie
    ADD CONSTRAINT observacao_serie_id_serie_fkey FOREIGN KEY (id_serie) REFERENCES public.serie_economica(id_serie);


--
-- TOC entry 4805 (class 2606 OID 16413)
-- Name: serie_economica serie_economica_id_fonte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serie_economica
    ADD CONSTRAINT serie_economica_id_fonte_fkey FOREIGN KEY (id_fonte) REFERENCES public.fonte_dados(id_fonte);


-- Completed on 2026-05-19 10:29:20

--
-- PostgreSQL database dump complete
--

\unrestrict mOrAs3LCGMoCFH0IjYh3uLigKZdgf8Ed1ldiEoxMxZmBKojF5IghEhJEpVgYluq

