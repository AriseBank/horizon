--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.signersaccount;
DROP INDEX public.sellingissuerindex;
DROP INDEX public.priceindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.buyingissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(56) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(56),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    sellerid character varying(56) NOT NULL,
    offerid bigint NOT NULL,
    sellingassettype integer,
    sellingassetcode character varying(12),
    sellingissuer character varying(56),
    buyingassettype integer,
    buyingassetcode character varying(12),
    buyingissuer character varying(56),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(56) NOT NULL,
    publickey character varying(56) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(56) NOT NULL,
    assettype integer NOT NULL,
    issuer character varying(56) NOT NULL,
    assetcode character varying(12) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ	99999979999999980	2	0	\N		AQAAAA==	0
GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	10000000000	8589934592	0	\N		AQAAAA==	0
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	9999999910	8589934601	0	GA5WBPYA5Y4WAEHXWR2UKO2UO4BUGHUQ74EUPKON2QHV4WRHOIRNKKH2	nullstyle.com	AgACAg==	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	0000000000000000000000000000000000000000000000000000000000000000	366ab1da319554c51293d7cbf7893a2373dbb0adb73bc8f86d4842995a948be6	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2arHaMZVUxRKT18v3iTojc9uwrbc7yPhtSEKZWpSL5gAAAAEBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
5d191b32fa6adbb3bf27a12d902766687b332a07caf728709078f1b05343bf4a	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	bf6705d99923a52a118bd51c4531264d345b06c6313470021941c8292a5dd282	2	1440711369	AAAAAejhCRj5wADHMRmr5UzwifWfkBXMk8SczwC16LmvtuaxiPa2RmZ/oW3eOBsnO1/fEaBfUOqQGLRPW+l5hQ4mkVEAAAAAVd+CyQAAAAEAAAAIAAAAAQAAAAEAAAAAh7fLiHtMkZiS4yrDThO6HDqMjfPTH1nmwb0nfxWrPAq/ZwXZmSOlKhGL1RxFMSZNNFsGxjE0cAIZQcgpKl3SggAAAAIBY0V4XYoAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
0bda274f6cf6142bddd203b2a046fb79d259bfe4fcf7ead1ffbb00d73e45da04	5d191b32fa6adbb3bf27a12d902766687b332a07caf728709078f1b05343bf4a	0a1c572b12993a40fadee06008674511cec59b195104dc2b570d785f9b0832c0	3	1440711370	AAAAAV0ZGzL6atuzvyehLZAnZmh7MyoHyvcocJB48bBTQ79KlRd6ANYreMTEKNGuxtjEkM+GKxZ/F4ehdy4mDwDivUkAAAAAVd+CygAAAAAAAAAAVjEgOvu+60yaQ7U+hdQHLa0SeVEC3zm02itf6G7T9g8KHFcrEpk6QPre4GAIZ0URzsWbGVEE3CtXDXhfmwgywAAAAAMBY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
e6b1dddf0506dae8b56ea91fec15c39cba00b4241734ee6cbbe35cadb2498886	0bda274f6cf6142bddd203b2a046fb79d259bfe4fcf7ead1ffbb00d73e45da04	2a35c7bd6499859a4387cf25c02cc05fdba317497a656e7c4b100c4d7cce3521	4	1440711371	AAAAAQvaJ09s9hQr3dIDsqBG+3nSWb/k/Pfq0f+7ANc+RdoEb5/sgW3LDJvvnJKx9WH1NJJy5wIDs1oJd+ZIgqvIWfgAAAAAVd+CywAAAAAAAAAAFBICk4JaSohP6AtY55zxi2OnZRjCwAz1UbSdP+fTA5AqNce9ZJmFmkOHzyXALMBf26MXSXplbnxLEAxNfM41IQAAAAQBY0V4XYoAAAAAAAAAAAAoAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
5d44f16fe56a65c4d0475cec852b0d4ee761470dfe143f53a36fb9b8c8c82094	e6b1dddf0506dae8b56ea91fec15c39cba00b4241734ee6cbbe35cadb2498886	6d1912dae30311cae445a651e51521c144231ac1fa71c846cae320574d3fd29d	5	1440711372	AAAAAeax3d8FBtrotW6pH+wVw5y6ALQkFzTubLvjXK2ySYiGmXLHXjSCbvMGBojrKUOtWFyYLcGL+pKK79YBNC7phzEAAAAAVd+CzAAAAAAAAAAAXOoD15m2LCKCR1Cq4IYnmF8H91TAIc8PTM5FeH/6Aa1tGRLa4wMRyuRFplHlFSHBRCMawfpxyEbK4yBXTT/SnQAAAAUBY0V4XYoAAAAAAAAAAAAyAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
e4caf8c215fd2c465b6c5dbd57de11353b2ac0377f1865c1731b3f4e5786a0b9	5d44f16fe56a65c4d0475cec852b0d4ee761470dfe143f53a36fb9b8c8c82094	3f41122794c99bf6ed19e2c00e520ac73e9fc25fad02741c29167d05543f0955	6	1440711373	AAAAAV1E8W/lamXE0Edc7IUrDU7nYUcN/hQ/U6NvubjIyCCURYGSZXee235CvuX7ltrKVEF+MC7Rx8Q2tLboso3IuG4AAAAAVd+CzQAAAAAAAAAAl1YXAENnwz6hWz48Q+trFbgdB8ingAAxdDLYvn1qOFs/QRInlMmb9u0Z4sAOUgrHPp/CX60CdBwpFn0FVD8JVQAAAAYBY0V4XYoAAAAAAAAAAAA8AAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
2b4a60897feec7d743409240436d6c3fc23146ebc84546078d7280ca74aa8b35	e4caf8c215fd2c465b6c5dbd57de11353b2ac0377f1865c1731b3f4e5786a0b9	5a3615040646a3a9574df5c07f4ddc72791e0eeec252e88dae42197dddc010d4	7	1440711374	AAAAAeTK+MIV/SxGW2xdvVfeETU7KsA3fxhlwXMbP05XhqC5hTnxGbCviiTZAOdUE1rFw5AxvC2fhPqI2UDImtT3yuMAAAAAVd+CzgAAAAAAAAAAnTpIWPm7yJsjC2C9hlIVeu2keN0zgYumMKm2pWdZYhdaNhUEBkajqVdN9cB/TdxyeR4O7sJS6I2uQhl93cAQ1AAAAAcBY0V4XYoAAAAAAAAAAABGAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
0954f604c55663bbfa409d624d4d40819e7cf79b2cc6a5ac69a531bcf924421d	2b4a60897feec7d743409240436d6c3fc23146ebc84546078d7280ca74aa8b35	bd4a56e68187b9e2a7401c9e89176d6e9841caf4bae0e0b8e93ebe38af1465ba	8	1440711375	AAAAAStKYIl/7sfXQ0CSQENtbD/CMUbryEVGB41ygMp0qos1g4Zt2/HFPvNAHh4m1B532CbTPOF6ZxbagQHjtyv0X+EAAAAAVd+CzwAAAAAAAAAA0gNaDl2NYNM9eQSYKHWCCy7rHibH+NpQrKELc23idza9SlbmgYe54qdAHJ6JF21umEHK9Lrg4LjpPr44rxRlugAAAAgBY0V4XYoAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
a930c4063e1253caa8ac50591f02671cd034b40eccafe25fbf5297c6e5a9b254	0954f604c55663bbfa409d624d4d40819e7cf79b2cc6a5ac69a531bcf924421d	3034612e671806fdce59ad273484df83fbc55cb3a4da84180b07e82815b0a3ef	9	1440711376	AAAAAQlU9gTFVmO7+kCdYk1NQIGefPebLMalrGmlMbz5JEIdUhkoqURw4WB0T2jcb1K6YDjg8eMVwG/YxUzNH9rlpv4AAAAAVd+C0AAAAAAAAAAAmPnCb9bQQgfrMYraZxf8zND9ldbvqWSLzawy+GScvIEwNGEuZxgG/c5ZrSc0hN+D+8Vcs6TahBgLB+goFbCj7wAAAAkBY0V4XYoAAAAAAAAAAABaAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
33e4b6c6886773c59b8470831b2ce512a85664a2c4e8c619ae0eb58766877f82	a930c4063e1253caa8ac50591f02671cd034b40eccafe25fbf5297c6e5a9b254	6899ac15fce63d476128d3f68523ebe0ccf7df156d1863ebce6f4182a0bb0d6a	10	1440711377	AAAAAakwxAY+ElPKqKxQWR8CZxzQNLQOzK/iX79Sl8blqbJUMt+1Q+PFaNAdQJ+26+atoNk0k58i4JR/ILMcMFeeWwIAAAAAVd+C0QAAAAAAAAAAZHkrxU2hGxXrWpgLZjF0Y5wqA8D8oPZk/B6LcDQx749omawV/OY9R2Eo0/aFI+vgzPffFW0YY+vOb0GCoLsNagAAAAoBY0V4XYoAAAAAAAAAAABkAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
9a4b81f2107106ae0fbd84863925a123a23ba3f6189baf69437812eaa9fb601d	33e4b6c6886773c59b8470831b2ce512a85664a2c4e8c619ae0eb58766877f82	3c2e55aebb384ab57035f5b80615e38653ea47f4a3e79ea10f62b868617484bd	11	1440711378	AAAAATPktsaIZ3PFm4Rwgxss5RKoVmSixOjGGa4OtYdmh3+CLBEF/8qLMmDQxk5VgHtl9LPM6YqOduMmrLWbHocEKrIAAAAAVd+C0gAAAAAAAAAAzB+fr6a/7E9EYd+w10yu1biHiDN22liIqWMYD3FA7r48LlWuuzhKtXA19bgGFeOGU+pH9KPnnqEPYrhoYXSEvQAAAAsBY0V4XYoAAAAAAAAAAABuAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
045513faf1c1d5f7d9657449a1e8c5b7ca1090983cce233329bdebfa3aa1cb42	9a4b81f2107106ae0fbd84863925a123a23ba3f6189baf69437812eaa9fb601d	3b9c14950f80b5d8c577016d97b1909172a00b6d828ea55b8fbeaef111bedd84	12	1440711379	AAAAAZpLgfIQcQauD72EhjkloSOiO6P2GJuvaUN4Euqp+2AdN89lDvMfDE2dcy26EEigaQENNT92Nu4LVLbvxUbiqnIAAAAAVd+C0wAAAAAAAAAA3z9hmASpL9tAVxktxD3XSOp3itxSvEmM6AUkwBS4ERk7nBSVD4C12MV3AW2XsZCRcqALbYKOpVuPvq7xEb7dhAAAAAwBY0V4XYoAAAAAAAAAAABuAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (sellerid, offerid, sellingassettype, sellingassetcode, sellingissuer, buyingassettype, buyingassetcode, buyingissuer, amount, pricen, priced, price, flags) FROM stdin;
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
GCXKG6RN4ONIEPCMNFB732A436Z5PNDSRLGWK7GBLCMQLIFO4S7EYWVU	GC23QF2HUE52AMXUFUH3AYJAXXGXXV2VHXYYR6EYXETPKDXZSAW67XO4	5
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	045513faf1c1d5f7d9657449a1e8c5b7ca1090983cce233329bdebfa3aa1cb42
historyarchivestate             	{\n    "version": 1,\n    "server": "72b501f-dirty",\n    "currentLedger": 12,\n    "currentBuckets": [\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "2f4e33ea5fbedcffbd8c4b87386adb1802cf96189e8dd7db2f0063d4b0f13785"\n        },\n        {\n            "curr": "ca48875e4f935d87fcbd69f41a5ab9f4057c1e42a2331d252e491d46e37a9bbc",\n            "next": {\n                "state": 1,\n                "output": "2f4e33ea5fbedcffbd8c4b87386adb1802cf96189e8dd7db2f0063d4b0f13785"\n            },\n            "snap": "30d1582f64af0c2caf3830d5226ca9648b11810fcf5073e955c5cb75a8142af7"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 1,\n                "output": "a6553c76f31dfc9ea77043c98125d0e45b792cae22baa34c23f74f34559d3e51"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, assettype, issuer, assetcode, tlimit, balance, flags) FROM stdin;
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
e8b5ece25598a5cc3ed7ad4eb4a0c3d83b8f207643f503958cebff1e2bcf36cc	2	1	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAAAAAAByWDl7wAAAEAjj7QKHtnoXXJB7kRWJg4ny8zfpnvo1ZCWND1yl8eVZTt713G02tuv8kTYa4lqzve0tJPE2Hw5CKRebOIeT+oF	6LXs4lWYpcw+161OtKDD2DuPIHZD9QOVjOv/HivPNswAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXhdif/2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAiZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8BY0V2CX4b9gAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
16daa941a3ea7697601aa52b18ab472fe7aa5d47dcd4eef6c813b3da4a5fe272	2	2	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAACVAvkAAAAAAAAAAAByWDl7wAAAEDUJ+uUliwk4feD5nEVE9WhQrAkW735dnC9U4oE3WWeeMQicAnx54pcsMSuVWo7INJiMV6Y4KAgTwaIwVRF16QL	FtqpQaPqdpdgGqUrGKtHL+eqXUfc1O72yBOz2kpf4nIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXYJfhvsAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAIAAAAAAAAAAAAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAJUC+QAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAiZsoQO1WNsVt3F8Usjl1958bojiNJpTkxW7N3clg5e8BY0VztXI37AAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
1a373c4fc81ea76295284db8f77be2fbb8f66cf506d471ab25f003090ae00244	3	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAUAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAQAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABruS+TAAAAEB1/qSLcW987bSFlPubQkEM74egDGbuBjOGv3LRJs1rCWbaKVc1zKozhDOA4szNpL/5qlpTgnMGPj7BVsByvJYN	Gjc8T8gep2KVKE2493vi+7j2bPUG1HGrJfADCQrgAkQAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+P2AAAAAgAAAAEAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAAAAAAAAQAAAAAAAAAAAAAA
798a22f61a78bd3df18338881dbeba4ade082bf651951cdabecb41bce4bca7a6	4	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABruS+TAAAAEBMV7PPsF6mq6ccMg6eYbxWjihXIi3OTp5rkXkUE57gq5yk/YyyfdtVz5HQ+e07VW2bgUwDtWcwwlhuA32EUEkK	eYoi9hp4vT3xgziIHb66St4IK/ZRlRzavstBvOS8p6YAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PsAAAAAgAAAAIAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PsAAAAAgAAAAIAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAQAAAAAAAAAAAAAA
1178a3144af427044f19c7e5b9d64d3f05ae92f2734c7ce54b05f979622187ac	5	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAEAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa7kvkwAAABAdneD9mmXKA+A8QoRUQlV/G//9/EYb4gLbwVTpGnKYZ7SzIp+Xm2HquPLTlfUggzvAdSe6HBbvMypTVhvpkIWCw==	EXijFEr0JwRPGcfludZNPwWukvJzTHzlSwX5eWIhh6wAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PiAAAAAgAAAAMAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAQAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PiAAAAAgAAAAMAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAgAAAAAAAAAAAAAA
4454d7b1a46b1784c0104f2154ab065aa7b8f3e134d83ca704131df58b0a9c02	6	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAACAAAAAQAAAAIAAAAAAAAAAAAAAAAAAAABruS+TAAAAEAZR27/OS7aEOrw/sNhUS5vEPJtWWZS/YUoFo71mdxdAagoDmxJDf3i+FCvWPSC/0SLRWqi7BxcsoewD9lO4FsC	RFTXsaRrF4TAEE8hVKsGWqe48+E02DynBBMd9YsKnAIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PYAAAAAgAAAAQAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAgAAAAAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PYAAAAAgAAAAQAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAgACAgAAAAAAAAAA
bf067d5a30a36d113d358921c1f325bbc93375ca9a02d838c8593f095139e5a8	7	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAADW51bGxzdHlsZS5jb20AAAAAAAAAAAAAAAAAAAGu5L5MAAAAQMMskyi5HXO05nMbffo+4wi8/TpGvz5b2mzy9xfpTzrT44JLYIZRg2ki7+c+HEwjXKtqrKdIEEa306XtB8MrpQM=	vwZ9WjCjbRE9NYkhwfMlu8kzdcqaAtg4yFk/CVE55agAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+POAAAAAgAAAAUAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAAAAgACAgAAAAAAAAAAAAAAAQAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+POAAAAAgAAAAUAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAANbnVsbHN0eWxlLmNvbQAAAAIAAgIAAAAAAAAAAA==
e011466896dec6497cf1562550d4f14e2723eadd5578c520d0d88a52406c6b28	8	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAGAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAEAAAAAAAAAAa7kvkwAAABAywomUSIzyWnD59LE7GYY5FtiXPtYYt/HcKNx6eku9PQG8gXBYuSCeGWZqNdHCUiE698CS0+iBkBLFwGw9zXBAA==	4BFGaJbexkl88VYlUNTxTicj6t1VeMUg0NiKUkBsaygAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PEAAAAAgAAAAYAAAAAAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAANbnVsbHN0eWxlLmNvbQAAAAIAAgIAAAAAAAAAAAAAAAEAAAABAAAAAQAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvjxAAAAAIAAAAGAAAAAQAAAAEAAAAAO2C/AO45YBD3tHVFO1R3A0MekP8JR6nN1A9eWidyItUAAAABAAAADW51bGxzdHlsZS5jb20AAAACAAICAAAAAQAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAEAAAAA
5ac9750bdb9f92ce92aea7e448f35954e947dbcc3557b0a2f7a570d186ff7a26	9	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAHAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAUAAAAAAAAAAa7kvkwAAABA7C5qCdJYOSVCf2pgcAPxhZIFBg86PpVhXD9Pw7F/51i7doEp0FXjqIxLIg4GM2F/soMyKtmWxWdrqtYrUU5QBA==	Wsl1C9ufks6SrqfkSPNZVOlH28w1V7Ci96Vw0Yb/eiYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+O6AAAAAgAAAAcAAAABAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAANbnVsbHN0eWxlLmNvbQAAAAIAAgIAAAABAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAQAAAAAAAAABAAAAAQAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL47oAAAACAAAABwAAAAEAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAQAAAA1udWxsc3R5bGUuY29tAAAAAgACAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAFAAAAAA==
b81e8383bffe6a7e68b0f17e73cc15141201b9039011db91d541f3a8f7c07c92	10	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAIAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABruS+TAAAAEB6mzvur2T5/rpzEUC5ivQXMSZnSBwfXNHY3zvdiM5tniwYq63NS8tV8qCunHpXuSRzblM68F2JOWtJyBu3Y2kM	uB6Dg7/+an5osPF+c8wVFBIBuQOQEduR1UHzqPfAfJIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+OwAAAAAgAAAAgAAAABAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAEAAAANbnVsbHN0eWxlLmNvbQAAAAIAAgIAAAABAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAABQAAAAAAAAABAAAAAQAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL47AAAAACAAAACAAAAAEAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAA1udWxsc3R5bGUuY29tAAAAAgACAgAAAAEAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAFAAAAAA==
750c53dcdb0cb8d68f94ef0be935f199b7d2d956c7d701a2edb168ab0d83f30d	11	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAJAAAAAAAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAQAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAAAa7kvkwAAABAA96FHIF+skJtAqIQHEE18l1OJO4eoNFhDghVFvaHpXFFetAH8whWFcds7upjDX76ZnhbTEhBv+TJpJBOLQ6vCw==	dQxT3NsMuNaPlO8L6TXxmbfS2VbH1wGi7bFoqw2D8w0AAAAAAAAACgAAAAAAAAABAAAAAAAAAAUAAAAAAAAAAA==	AAAAAAAAAAEAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+OmAAAAAgAAAAkAAAABAAAAAQAAAAA7YL8A7jlgEPe0dUU7VHcDQx6Q/wlHqc3UD15aJ3Ii1QAAAAAAAAANbnVsbHN0eWxlLmNvbQAAAAIAAgIAAAABAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAABQAAAAAAAAABAAAAAQAAAAEAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL46YAAAACAAAACQAAAAAAAAABAAAAADtgvwDuOWAQ97R1RTtUdwNDHpD/CUepzdQPXlonciLVAAAAAAAAAA1udWxsc3R5bGUuY29tAAAAAgACAgAAAAAAAAAA
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, assetcode);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance) WHERE (balance >= 1000000000);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: buyingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX buyingissuerindex ON offers USING btree (buyingissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: sellingissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sellingissuerindex ON offers USING btree (sellingissuer);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--
