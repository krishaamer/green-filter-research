
import warnings
warnings.filterwarnings("ignore")

import networkx as nx
import matplotlib.pyplot as plt

def planned_behavior_chart():
    # Build the graph using networkx for automatic layout
    G = nx.DiGraph()

    # Add nodes
    G.add_node("Behavioral Beliefs")
    G.add_node("Normative Beliefs")
    G.add_node("Control Beliefs")
    G.add_node("Attitude")
    G.add_node("Subjective Norm")
    G.add_node("Perceived Control")
    G.add_node("Intention")
    G.add_node("Actual Control")
    G.add_node("Behavior")

    # Add directed edges
    G.add_edge("Behavioral Beliefs", "Attitude")
    G.add_edge("Normative Beliefs", "Subjective Norm")
    G.add_edge("Control Beliefs", "Perceived Control")
    G.add_edge("Attitude", "Intention")
    G.add_edge("Subjective Norm", "Intention")
    G.add_edge("Perceived Control", "Intention")
    G.add_edge("Intention", "Behavior")
    G.add_edge("Perceived Control", "Behavior")
    G.add_edge("Actual Control", "Behavior")

    # Graphviz layout for neat separation
    pos = nx.nx_agraph.graphviz_layout(G, prog='dot')

    # Draw
    plt.figure(figsize=(11, 6))
    nx.draw(G, pos, with_labels=True, node_size=6000, node_color='white', edge_color='black',
            linewidths=2, font_size=12, font_weight='bold', font_color='black', arrowsize=25)
    plt.title("Theory of Planned Behavior", fontsize=16)
    plt.tight_layout()
    plt.show()
