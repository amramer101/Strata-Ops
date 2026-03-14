"""
VProfile Stack — Full Architecture Diagram
==========================================
Requirements:
    pip install diagrams
    sudo apt install graphviz   # Linux
    brew install graphviz       # Mac
    choco install graphviz      # Windows

Run:
    python vprofile_diagram.py
Output:
    vprofile_architecture.png  (same folder)
"""

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, InternetGateway
from diagrams.aws.storage import S3
from diagrams.aws.security import IAMRole
from diagrams.onprem.iac import Terraform, Ansible
from diagrams.onprem.container import Docker
from diagrams.onprem.network import Nginx
from diagrams.onprem.database import MySQL
from diagrams.onprem.queue import RabbitMQ
from diagrams.onprem.inmemory import Memcached
from diagrams.generic.compute import Rack

# ─────────────────────────────────────────────────────────────────────────────
#  Graph-level attributes (dark theme)
# ─────────────────────────────────────────────────────────────────────────────
GRAPH_ATTR = {
    "bgcolor":    "#0D1117",
    "fontcolor":  "#F1F5F9",
    "fontname":   "Helvetica",
    "fontsize":   "22",
    "pad":        "0.8",
    "splines":    "ortho",
    "nodesep":    "0.7",
    "ranksep":    "1.2",
    "rankdir":    "TB",
    "compound":   "true",
}

CLUSTER_ATTR_AWS = {
    "bgcolor":   "#1A1F2E",
    "fontcolor": "#FF9900",
    "fontname":  "Helvetica-Bold",
    "fontsize":  "15",
    "style":     "filled,rounded",
    "color":     "#FF9900",
    "penwidth":  "3",
}

CLUSTER_ATTR_VPC = {
    "bgcolor":   "#111827",
    "fontcolor": "#60A5FA",
    "fontname":  "Helvetica-Bold",
    "fontsize":  "13",
    "style":     "filled,rounded",
    "color":     "#3B82F6",
    "penwidth":  "2",
}

CLUSTER_ATTR_SUBNET = {
    "bgcolor":   "#0F172A",
    "fontcolor": "#22D3EE",
    "fontname":  "Helvetica-Bold",
    "fontsize":  "11",
    "style":     "filled,rounded",
    "color":     "#06B6D4",
    "penwidth":  "2",
}

CLUSTER_ATTR_SG = {
    "bgcolor":   "#1E293B",
    "fontcolor": "#F59E0B",
    "fontname":  "Helvetica",
    "fontsize":  "10",
    "style":     "filled,rounded",
    "color":     "#F59E0B",
    "penwidth":  "1.5",
}

CLUSTER_ATTR_DOCKER = {
    "bgcolor":   "#172554",
    "fontcolor": "#38BDF8",
    "fontname":  "Helvetica-Bold",
    "fontsize":  "12",
    "style":     "filled,rounded",
    "color":     "#3B82F6",
    "penwidth":  "2",
}

CLUSTER_ATTR_FE = {
    "bgcolor":   "#0C2D48",
    "fontcolor": "#38BDF8",
    "fontname":  "Helvetica",
    "fontsize":  "10",
    "style":     "filled,dashed",
    "color":     "#38BDF8",
    "penwidth":  "1.5",
}

CLUSTER_ATTR_BE = {
    "bgcolor":   "#1C1033",
    "fontcolor": "#A78BFA",
    "fontname":  "Helvetica",
    "fontsize":  "10",
    "style":     "filled,dashed",
    "color":     "#A78BFA",
    "penwidth":  "1.5",
}

CLUSTER_ATTR_DEV = {
    "bgcolor":   "#1A1000",
    "fontcolor": "#FBBF24",
    "fontname":  "Helvetica-Bold",
    "fontsize":  "13",
    "style":     "filled,rounded",
    "color":     "#F59E0B",
    "penwidth":  "2",
}

NODE_ATTR = {
    "fontcolor": "#F1F5F9",
    "fontname":  "Helvetica",
    "fontsize":  "11",
}

# ─────────────────────────────────────────────────────────────────────────────
#  Diagram
# ─────────────────────────────────────────────────────────────────────────────
with Diagram(
    "\nVProfile Stack — Infrastructure Architecture\nTerraform  •  Ansible  •  Docker Compose  •  AWS EC2",
    filename="vprofile_architecture",
    outformat="png",
    show=False,
    graph_attr=GRAPH_ATTR,
    node_attr=NODE_ATTR,
):

    # ── INTERNET ──────────────────────────────────────────────────────────────
    internet = InternetGateway("Internet\n:80 HTTP")

    # ── DEVELOPER MACHINE ─────────────────────────────────────────────────────
    with Cluster("💻  Developer Machine  (Local)", graph_attr=CLUSTER_ATTR_DEV):

        with Cluster("IaC Tools", graph_attr={
            "bgcolor": "#231500", "fontcolor": "#FBBF24",
            "style": "filled,rounded", "color": "#92400E", "penwidth": "1",
        }):
            tf      = Terraform("Terraform\nProvisions AWS Infra")
            ansible = Ansible("Ansible\nInstalls Docker\n+ Deploys Stack")

        s3 = S3("S3 Bucket\ns3-terraform-2026\n(Remote TF State)")

    # ── AWS CLOUD ─────────────────────────────────────────────────────────────
    with Cluster("☁  AWS Cloud  —  eu-central-1 (Frankfurt)", graph_attr=CLUSTER_ATTR_AWS):

        # ── VPC ───────────────────────────────────────────────────────────────
        with Cluster("🔷  VPC   10.0.0.0/16", graph_attr=CLUSTER_ATTR_VPC):

            # ── Public Subnet ─────────────────────────────────────────────────
            with Cluster("🌐  Public Subnet   10.0.0.0/24  |  AZ: eu-central-1a",
                          graph_attr=CLUSTER_ATTR_SUBNET):

                # ── Security Group ────────────────────────────────────────────
                with Cluster(
                    "🛡  Security Group: Docker-SG\n"
                    "Inbound: SSH :22 (My IP)  •  HTTP :80 (0.0.0.0/0)\n"
                    "Outbound: ALL",
                    graph_attr=CLUSTER_ATTR_SG,
                ):
                    ec2 = EC2("EC2  t2.medium\nUbuntu 22.04 LTS\nPublic IP")

                    # ── Docker Engine ─────────────────────────────────────────
                    with Cluster("🐳  Docker Engine", graph_attr=CLUSTER_ATTR_DOCKER):

                        # Frontend network
                        with Cluster("frontend_net  (bridge)", graph_attr=CLUSTER_ATTR_FE):
                            nginx  = Nginx("vproweb\nNginx 1.25.3\n:80")
                            tomcat = Rack("vproapp\nTomcat 10 / JDK21\n:8080")

                        # Backend network
                        with Cluster("backend_net  (internal — isolated)", graph_attr=CLUSTER_ATTR_BE):
                            mysql     = MySQL("vprodb\nMySQL 8.0.33\n:3306")
                            rabbit    = RabbitMQ("vpromq01\nRabbitMQ 3\n:5672 / :15672")
                            memcached = Memcached("vprocache01\nMemcached\n:11211")

    # ─────────────────────────────────────────────────────────────────────────
    #  EDGES
    # ─────────────────────────────────────────────────────────────────────────

    # Terraform → S3 (remote state)
    tf >> Edge(
        label="Remote State",
        color="#22C55E", style="dashed", penwidth="1.5"
    ) >> s3

    # Terraform → EC2 (provision)
    tf >> Edge(
        label="① Provision\nEC2 + VPC + SG + Key Pair",
        color="#7C3AED", style="dashed", penwidth="2"
    ) >> ec2

    # Ansible → EC2 (deploy)
    ansible >> Edge(
        label="② Install Docker\n   Deploy Stack via SSH",
        color="#EF4444", style="dashed", penwidth="2"
    ) >> ec2

    # Internet → Nginx
    internet >> Edge(
        label="HTTP :80",
        color="#60A5FA", penwidth="3"
    ) >> nginx

    # Nginx → Tomcat (reverse proxy)
    nginx >> Edge(
        label="proxy_pass :8080",
        color="#22C55E", penwidth="2"
    ) >> tomcat

    # Tomcat → backends (depend on healthcheck)
    tomcat >> Edge(
        label="JDBC :3306",
        color="#3B82F6", penwidth="2"
    ) >> mysql

    tomcat >> Edge(
        label="Cache :11211",
        color="#9CA3AF", penwidth="1.5"
    ) >> memcached

    tomcat >> Edge(
        label="AMQP :5672",
        color="#F59E0B", penwidth="1.5"
    ) >> rabbit

print("✅  Saved → vprofile_architecture.png")