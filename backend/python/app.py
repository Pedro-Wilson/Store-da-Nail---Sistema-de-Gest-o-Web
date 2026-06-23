"""
Dashboard de Estoque - Loja de Produtos de Unha
=================================================
Dashboard interativo construído com Streamlit + Plotly, conectado a um
banco de dados PostgreSQL com o schema:

    tb_produto       (cod_produto, vch_nome, vch_marca, num_preco, vch_categoria)
    tb_lote          (cod_lote, cod_produto, dat_validade, int_quantidade)
    tb_movimentacao  (cod_mov, cod_produto, chr_tipo ['E'/'S'], dat_mov, int_qtd, vch_motivo)

Como executar:
    1. pip install -r requirements.txt
    2. Configure as credenciais do banco (variáveis de ambiente OU
       diretamente na barra lateral ao abrir o app).
    3. streamlit run app.py

O app também funciona em "modo demonstração" com SQLite caso você não
informe uma conexão Postgres - útil para testar o layout antes de
plugar no banco real.
"""

import os
from datetime import date, datetime

import pandas as pd
import plotly.express as px
import streamlit as st
from sqlalchemy import create_engine, text

# ------------------------------------------------------------------
# Configuração da página
# ------------------------------------------------------------------
st.set_page_config(
    page_title="Estoque - Store da nail",
    layout="wide",
    initial_sidebar_state="expanded",
)

DIAS_ALERTA_VALIDADE = 60   # produtos vencendo em até X dias = alerta
ESTOQUE_MINIMO_PADRAO = 10  # considerado "estoque baixo"


# ------------------------------------------------------------------
# Conexão com o banco
# ------------------------------------------------------------------
@st.cache_resource(show_spinner=False)
def get_engine(conn_string: str):
    """Cria  a engine de conexão com o banco."""
    return create_engine(conn_string, pool_pre_ping=True)


def montar_conn_string_postgres(host, port, dbname, user, password):
    return f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}"


def criar_banco_demo_sqlite():
    """
Usado pra debugar o código sem precisar de um banco Postgres real. Cria um banco SQLite em memória com dados de exemplo para testar o dashboard.
    """
    engine = create_engine("sqlite:///:memory:")
    produtos = pd.DataFrame([
        (1, "Esmalte Rosa Neon", "Impala", 10.00, 19.90, "Esmaltes"),
        (2, "Natura Chronos Firming Cream", "Natura", 70.00, 125.00, "Skincare"),
        (3, "Boticário Floratta Red", "Boticário", 90.00, 149.90, "Perfumaria"),
        (4, "Eudora Matefix Lipstick", "Eudora", 20.00, 39.90, "Maquiagem"),
        (5, "Base Matte", "Obsidian", 22.00, 45.00, "Maquiagem"),
        (6, "Esmalte Gel Premium", "Marca X", 9.00, 18.50, "Unhas"),
        (7, "Batom Matte Fix", "Eudora", 18.00, 35.90, "Maquiagem"),
        (8, "Creme Chronos Antissinais", "Natura", 65.00, 120.00, "Skincare"),
    ], columns=["cod_produto", "vch_nome", "vch_marca", "preco_custo", "preco_venda", "vch_categoria"])
    produtos["imagem_url"] = None
    produtos.to_sql("tb_produto", engine, index=False, if_exists="replace")

    lotes = pd.DataFrame([
        (1, 1, "2026-12-30", 50),
        (2, 1, "2026-06-15", 20),
        (3, 2, "2027-05-20", 10),
        (4, 4, "2026-08-10", 15),
        (5, 6, "2026-07-25", 30),
        (6, 7, "2026-08-22", 30),
    ], columns=["cod_lote", "cod_produto", "dat_validade", "int_quantidade"])
    lotes.to_sql("tb_lote", engine, index=False, if_exists="replace")

    movs = pd.DataFrame([
        (1, 1, "E", "2026-05-31 22:28:43", 70, "Entrada de fornecedor - Reposição Mensal"),
        (2, 1, "S", "2026-06-02 10:00:00", 5, "Venda realizada via WhatsApp"),
        (3, 4, "S", "2026-06-03 09:00:00", 1, "Produto danificado no transporte"),
        (4, 6, "E", "2026-06-05 14:00:00", 40, "Reposição de fornecedor"),
        (5, 6, "S", "2026-06-10 16:00:00", 12, "Venda balcão"),
    ], columns=["cod_mov", "cod_produto", "chr_tipo", "dat_mov", "int_qtd", "vch_motivo"])
    movs.to_sql("tb_movimentacao", engine, index=False, if_exists="replace")

    return engine


# ------------------------------------------------------------------
# Consultas (cacheadas por um curto período para manter a sensação de
# "tempo real" sem martelar o banco a cada interação)
# ------------------------------------------------------------------
@st.cache_data(ttl=60, show_spinner=False)
def carregar_estoque(_engine):
    query = """
        SELECT
            p.cod_produto,
            p.vch_nome      AS produto,
            p.vch_marca     AS marca,
            p.vch_categoria AS categoria,
            p.preco_custo   AS preco_custo,
            p.preco_venda   AS preco,
            p.imagem_url    AS imagem_url,
            l.cod_lote,
            l.dat_validade,
            l.int_quantidade AS quantidade
        FROM tb_produto p
        LEFT JOIN tb_lote l ON l.cod_produto = p.cod_produto
    """
    df = pd.read_sql(text(query), _engine)
    df["dat_validade"] = pd.to_datetime(df["dat_validade"], errors="coerce")
    df["quantidade"] = df["quantidade"].fillna(0)
    return df


@st.cache_data(ttl=60, show_spinner=False)
def carregar_movimentacoes(_engine):
    query = """
        SELECT
            m.cod_mov,
            m.cod_produto,
            p.vch_nome      AS produto,
            p.vch_categoria AS categoria,
            m.chr_tipo      AS tipo,
            m.dat_mov,
            m.int_qtd       AS quantidade,
            m.vch_motivo    AS motivo
        FROM tb_movimentacao m
        LEFT JOIN tb_produto p ON p.cod_produto = m.cod_produto
    """
    df = pd.read_sql(text(query), _engine)
    df["dat_mov"] = pd.to_datetime(df["dat_mov"], errors="coerce")
    return df


# ------------------------------------------------------------------
# Barra lateral - conexão e filtros
# ------------------------------------------------------------------
st.sidebar.title("Configuração")

modo = st.sidebar.radio(
    "Fonte de dados",
    ["Conectar ao PostgreSQL", "Modo demonstração (SQLite local)"],
    index=0,
)

engine = None

if modo == "Conectar ao PostgreSQL":
    with st.sidebar.expander("Credenciais do banco", expanded=True):
        host = st.text_input("Host", value=os.getenv("PGHOST", "localhost"))
        port = st.text_input("Porta", value=os.getenv("PGPORT", "5432"))
        dbname = st.text_input("Banco", value=os.getenv("PGDATABASE", "store_da_nail"))
        user = st.text_input("Usuário", value=os.getenv("PGUSER", "postgres"))
        password = st.text_input(
            "Senha", value=os.getenv("PGPASSWORD", "6965"), type="password"
        )
        conectar = st.button("Conectar", use_container_width=True)

    if conectar or "engine_ok" in st.session_state:
        try:
            conn_str = montar_conn_string_postgres(host, port, dbname, user, password)
            engine = get_engine(conn_str)
            # testa a conexão
            with engine.connect() as c:
                c.execute(text("SELECT 1"))
            st.session_state["engine_ok"] = True
            st.sidebar.success("Conectado com sucesso!")
        except Exception as e:
            st.sidebar.error(f"Falha na conexão: {e}")
            engine = None
else:
    engine = criar_banco_demo_sqlite()
    st.sidebar.info("Usando dados de demonstração.")

if engine is None:
    st.title("Dashboard cde Estoque")
    st.info(
        "Informe as credenciais do PostgreSQL na barra lateral e clique em "
        "**Conectar**, ou selecione o **modo demonstração** para ver o "
        "dashboard funcionando com dados de exemplo."
    )
    st.stop()


# ------------------------------------------------------------------
# Carrega os dados
# ------------------------------------------------------------------
try:
    df_estoque = carregar_estoque(engine)
    df_mov = carregar_movimentacoes(engine)
except Exception as e:
    st.error(f"Erro ao consultar o banco de dados: {e}")
    st.stop()

if df_estoque.empty:
    st.warning("Nenhum produto encontrado no banco.")
    st.stop()

hoje = pd.Timestamp(date.today())
df_estoque["dias_para_vencer"] = (df_estoque["dat_validade"] - hoje).dt.days

# ------------------------------------------------------------------
# Filtros (sidebar)
# ------------------------------------------------------------------
st.sidebar.divider()
st.sidebar.header("Filtros")

categorias = sorted(df_estoque["categoria"].dropna().unique().tolist())
marcas = sorted(df_estoque["marca"].dropna().unique().tolist())

f_categorias = st.sidebar.multiselect("Categoria", categorias, default=categorias)
f_marcas = st.sidebar.multiselect("Marca", marcas, default=marcas)
estoque_minimo = st.sidebar.number_input(
    "Considerar 'estoque baixo' abaixo de", min_value=0, value=ESTOQUE_MINIMO_PADRAO
)
dias_alerta = st.sidebar.slider(
    "Alertar validade nos próximos (dias)", 0, 180, DIAS_ALERTA_VALIDADE
)

mask = df_estoque["categoria"].isin(f_categorias) & df_estoque["marca"].isin(f_marcas)
df_f = df_estoque[mask].copy()

st.sidebar.divider()
if st.sidebar.button("Atualizar dados agora"):
    st.cache_data.clear()
    st.rerun()


# ------------------------------------------------------------------
# Cabeçalho + KPIs
# ------------------------------------------------------------------
st.title("Dashboard de Estoque - Loja de Produtos de Unha")
st.caption(f"Última atualização: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")

estoque_por_produto = (
    df_f.groupby(["cod_produto", "produto"], as_index=False)["quantidade"].sum()
)

total_produtos = estoque_por_produto["cod_produto"].nunique()
total_unidades = int(estoque_por_produto["quantidade"].sum())
valor_total_estoque = (
    df_f.groupby("cod_produto")
    .agg(qtd=("quantidade", "sum"), preco=("preco", "first"))
    .assign(valor=lambda d: d["qtd"] * d["preco"])["valor"]
    .sum()
)
valor_custo_estoque = (
    df_f.groupby("cod_produto")
    .agg(qtd=("quantidade", "sum"), custo=("preco_custo", "first"))
    .assign(valor=lambda d: d["qtd"] * d["custo"])["valor"]
    .sum()
)
margem_potencial = valor_total_estoque - valor_custo_estoque
produtos_estoque_baixo = (
    estoque_por_produto[estoque_por_produto["quantidade"] < estoque_minimo]
)
lotes_vencendo = df_f[
    (df_f["dias_para_vencer"] >= 0) & (df_f["dias_para_vencer"] <= dias_alerta)
]
lotes_vencidos = df_f[df_f["dias_para_vencer"] < 0]

c1, c2, c3, c4, c5, c6 = st.columns(6)
c1.metric("Produtos (filtro)", total_produtos)
c2.metric("Unidades em estoque", f"{total_unidades:,}".replace(",", "."))
c3.metric("Valor em estoque (venda)", f"R$ {valor_total_estoque:,.2f}")
c4.metric("Margem potencial", f"R$ {margem_potencial:,.2f}")
c5.metric("Estoque baixo", len(produtos_estoque_baixo))
c6.metric("Vencendo em breve", len(lotes_vencendo), delta=f"{len(lotes_vencidos)} vencidos", delta_color="inverse")

st.divider()

# ------------------------------------------------------------------
# Abas principais
# ------------------------------------------------------------------
tab_visao, tab_validade, tab_mov, tab_dados = st.tabs(
    ["Visão Geral", "Validade e Alertas", "Movimentações", "Dados Detalhados"]
)

# --- Aba: Visão Geral -------------------------------------------------
with tab_visao:
    col1, col2 = st.columns(2)

    with col1:
        estoque_categoria = (
            df_f.groupby("categoria", as_index=False)["quantidade"].sum()
            .sort_values("quantidade", ascending=False)
        )
        fig = px.bar(
            estoque_categoria, x="categoria", y="quantidade",
            title="Estoque total por categoria",
            labels={"categoria": "Categoria", "quantidade": "Unidades"},
            color="categoria",
        )
        fig.update_layout(showlegend=False)
        st.plotly_chart(fig, use_container_width=True)

    with col2:
        estoque_marca = (
            df_f.groupby("marca", as_index=False)["quantidade"].sum()
            .sort_values("quantidade", ascending=False)
        )
        fig = px.pie(
            estoque_marca, names="marca", values="quantidade",
            title="Distribuição do estoque por marca", hole=0.4,
        )
        st.plotly_chart(fig, use_container_width=True)

    st.subheader("Top 10 produtos por quantidade em estoque")
    top10 = estoque_por_produto.sort_values("quantidade", ascending=False).head(10)
    fig = px.bar(
        top10, x="quantidade", y="produto", orientation="h",
        labels={"quantidade": "Unidades", "produto": "Produto"},
    )
    fig.update_layout(yaxis={"categoryorder": "total ascending"})
    st.plotly_chart(fig, use_container_width=True)

    if not produtos_estoque_baixo.empty:
        st.subheader("Produtos com estoque baixo")
        st.dataframe(
            produtos_estoque_baixo.sort_values("quantidade"),
            use_container_width=True, hide_index=True,
        )

# --- Aba: Validade e Alertas -----------------------------------------
with tab_validade:
    st.subheader("Lotes por proximidade de vencimento")

    def status_validade(d):
        if pd.isna(d):
            return "Sem validade"
        if d < 0:
            return "Vencido"
        if d <= dias_alerta:
            return "Vence em breve"
        return "OK"

    df_f["status_validade"] = df_f["dias_para_vencer"].apply(status_validade)

    col1, col2 = st.columns([1, 2])
    with col1:
        contagem_status = df_f["status_validade"].value_counts().reset_index()
        contagem_status.columns = ["status", "qtd_lotes"]
        cores = {
            "Vencido": "#d62728",
            "Vence em breve": "#ff7f0e",
            "OK": "#2ca02c",
            "Sem validade": "#7f7f7f",
        }
        fig = px.pie(
            contagem_status, names="status", values="qtd_lotes",
            title="Status de validade dos lotes",
            color="status", color_discrete_map=cores,
        )
        st.plotly_chart(fig, use_container_width=True)

    with col2:
        criticos = df_f[df_f["status_validade"].isin(["Vencido", "Vence em breve"])]
        criticos = criticos.sort_values("dias_para_vencer")
        if criticos.empty:
            st.success("Nenhum lote vencido ou próximo do vencimento.")
        else:
            st.dataframe(
                criticos[[
                    "produto", "marca", "categoria", "cod_lote",
                    "dat_validade", "quantidade", "dias_para_vencer", "status_validade"
                ]].rename(columns={
                    "dat_validade": "Validade", "quantidade": "Qtd.",
                    "dias_para_vencer": "Dias p/ vencer", "status_validade": "Status",
                }),
                use_container_width=True, hide_index=True,
            )

    st.subheader("Linha do tempo de vencimentos")
    timeline = df_f.dropna(subset=["dat_validade"]).copy()
    if not timeline.empty:
        fig = px.scatter(
            timeline, x="dat_validade", y="produto", size="quantidade",
            color="status_validade",
            color_discrete_map={
                "Vencido": "#d62728", "Vence em breve": "#ff7f0e", "OK": "#2ca02c",
            },
            labels={"dat_validade": "Data de validade", "produto": "Produto"},
            title="Vencimento dos lotes por produto",
        )
        st.plotly_chart(fig, use_container_width=True)

# --- Aba: Movimentações -----------------------------------------------
with tab_mov:
    if df_mov.empty:
        st.info("Nenhuma movimentação registrada ainda.")
    else:
        df_mov_f = df_mov[df_mov["categoria"].isin(f_categorias)] if f_categorias else df_mov

        col1, col2 = st.columns(2)
        with col1:
            min_d = df_mov_f["dat_mov"].min().date()
            max_d = df_mov_f["dat_mov"].max().date()
            periodo = st.date_input(
                "Período", value=(min_d, max_d), min_value=min_d, max_value=max_d
            )
        with col2:
            tipos = st.multiselect(
                "Tipo de movimentação", ["E", "S"], default=["E", "S"],
                format_func=lambda t: "Entrada" if t == "E" else "Saída",
            )

        if isinstance(periodo, tuple) and len(periodo) == 2:
            ini, fim = periodo
            df_mov_f = df_mov_f[
                (df_mov_f["dat_mov"].dt.date >= ini) & (df_mov_f["dat_mov"].dt.date <= fim)
            ]
        df_mov_f = df_mov_f[df_mov_f["tipo"].isin(tipos)]

        c1, c2, c3 = st.columns(3)
        entradas = df_mov_f.loc[df_mov_f["tipo"] == "E", "quantidade"].sum()
        saidas = df_mov_f.loc[df_mov_f["tipo"] == "S", "quantidade"].sum()
        c1.metric("Total de entradas", int(entradas))
        c2.metric("Total de saídas", int(saidas))
        c3.metric("Saldo do período", int(entradas - saidas))

        df_mov_f["data"] = df_mov_f["dat_mov"].dt.date
        evolucao = (
            df_mov_f.groupby(["data", "tipo"], as_index=False)["quantidade"].sum()
        )
        evolucao["tipo_label"] = evolucao["tipo"].map({"E": "Entrada", "S": "Saída"})
        fig = px.line(
            evolucao, x="data", y="quantidade", color="tipo_label", markers=True,
            labels={"data": "Data", "quantidade": "Unidades", "tipo_label": "Tipo"},
            title="Entradas x Saídas ao longo do tempo",
        )
        st.plotly_chart(fig, use_container_width=True)

        st.subheader("Movimentações mais recentes")
        st.dataframe(
            df_mov_f.sort_values("dat_mov", ascending=False)[
                ["dat_mov", "produto", "tipo", "quantidade", "motivo"]
            ].rename(columns={
                "dat_mov": "Data/Hora", "produto": "Produto",
                "tipo": "Tipo", "quantidade": "Qtd.", "motivo": "Motivo",
            }),
            use_container_width=True, hide_index=True,
        )

# --- Aba: Dados Detalhados --------------------------------------------
with tab_dados:
    st.subheader("Estoque detalhado (produto + lote)")
    st.dataframe(
        df_f.sort_values(["produto", "dat_validade"])[
            ["produto", "marca", "categoria", "preco_custo", "preco", "cod_lote",
             "dat_validade", "quantidade", "dias_para_vencer"]
        ].rename(columns={
            "produto": "Produto", "marca": "Marca", "categoria": "Categoria",
            "preco_custo": "Custo (R$)", "preco": "Venda (R$)", "cod_lote": "Lote",
            "dat_validade": "Validade", "quantidade": "Qtd.",
            "dias_para_vencer": "Dias p/ vencer",
        }),
        use_container_width=True, hide_index=True,
    )

    csv = df_f.to_csv(index=False).encode("utf-8")
    st.download_button(
        "Baixar dados filtrados (CSV)", data=csv,
        file_name="estoque_filtrado.csv", mime="text/csv",
    )