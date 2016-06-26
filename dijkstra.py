# Redes sem Fio
# UTFPR
# Danilo Dolci
# Renan Greca
# Junho de 2016

# ??? FLOODING para descoberta de rede

import argparse
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

parser = argparse.ArgumentParser(description='''Runs Dijkstra algorithm on graph.''')
parser.add_argument('-g', '--graph', type=str, required=True,
                    help='''File which contains graph edges''')

def main(args):
    edges = []
    weights = {}

    with open(args.graph) as file:
        rows = file.readlines()

        for row in rows:
            edge = row.split()
            edges.append( (edge[0], edge[1], edge[2]) )
            weights[(edge[0], edge[1])] = edge[2]

        G = build_graph(edges)

        source = nx.nodes(G)[0]
        dist, prev = dijkstra(G, source)
        print 'dist:', dist
        print 'prev:', prev

        draw_graph(G, labels=weights, graph_layout='spring')

# Converts input into an nx graph
# edges is in format [(node, node, weight)]
def build_graph(edges):
    G=nx.Graph()

    # add edges
    for edge in edges:
        G.add_edge(edge[0], edge[1], weight=int(edge[2]))

    return G

def draw_graph(G, labels=None, graph_layout='shell',
               node_size=1600, node_color='blue', node_alpha=0.3,
               node_text_size=12,
               edge_color='blue', edge_alpha=0.3, edge_tickness=1,
               edge_text_pos=0.3,
               text_font='sans-serif'):

    # these are different layouts for the network you may try
    # shell seems to work best
    if graph_layout == 'spring':
        graph_pos=nx.spring_layout(G)
    elif graph_layout == 'spectral':
        graph_pos=nx.spectral_layout(G)
    elif graph_layout == 'random':
        graph_pos=nx.random_layout(G)
    else:
        graph_pos=nx.shell_layout(G)

    # draw graph
    nx.draw_networkx_nodes(G,graph_pos,node_size=node_size, 
                           alpha=node_alpha, node_color=node_color)
    nx.draw_networkx_edges(G,graph_pos,width=edge_tickness,
                           alpha=edge_alpha,edge_color=edge_color)
    nx.draw_networkx_labels(G, graph_pos,font_size=node_text_size,
                            font_family=text_font)

    if labels is None:
        labels = range(len(G))

    edge_labels = dict(zip(G, labels))
    nx.draw_networkx_edge_labels(G, graph_pos, edge_labels=labels, 
                                 label_pos=edge_text_pos)

    # show graph
    plt.show()

# Dijkstra's algorithm, based on pseudocode found at
# https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm#Pseudocode
def dijkstra(G, source):

    q = []
    dist = {}
    prev = {}

    for v in nx.nodes(G):
        dist[v] = np.Infinity
        prev[v] = None
        q.append(v)

    dist[source] = 0

    while q:
        u = min_dist(q, dist)
        q.remove(u)

        for v in nx.all_neighbors(G, u):

            alt = dist[u] + G[u][v]['weight']

            if alt < dist[v]:
                dist[v] = alt
                prev[v] = u

    return dist, prev

def min_dist(q, dist):
    m = np.Infinity
    i = None
    for n in q:
        if dist[n] < m:
            m = dist[n]
            i = n

    return i

if __name__ == '__main__':
    args = parser.parse_args()
    main(args)