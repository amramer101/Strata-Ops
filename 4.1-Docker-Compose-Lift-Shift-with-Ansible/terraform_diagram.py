from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, PublicSubnet, InternetGateway
from diagrams.onprem.iac import Terraform

# تم تفعيل show=True عشان يفتحهولك تلقائياً بعد الرسم
with Diagram("Terraform-AWS Infrastructure Architecture", show=True):
    
    # تعريف العناصر الخارجية
    tf = Terraform("Config & State")
    igw = InternetGateway("Internet Gateway")
    
    # استخدام Cluster لعمل صندوق للمنطقة بأكملها (AWS Cloud)
    # وإعطاؤها خلفية ولون لتمييزها
    with Cluster("AWS Cloud", graph_attr={"bg_color": "white", "style": "dashed"}):
        
        # تعريف الـ VPC كصندوق داخلي أول
        # إضافة الـ label للـ VPC لتوضيح الـ CIDR
        with Cluster("VPC", graph_attr={"bg_color": "#e0f2f1", "label": "VPC (10.0.0.0/16)"}):
            
            # تعريف الـ Availability Zone كصندوق داخلي تاني
            # (تمت إضافة لون مختلف)
            with Cluster("Availability Zone 1a", graph_attr={"bg_color": "#b2dfdb"}):
                
                # تعريف الـ Public Subnet كصندوق داخلي تالت
                # (تمت إضافة لون ثالث، وتم تعديل الـ label لتوضيح الـ CIDR الفرعي)
                with Cluster("Public Subnet", graph_attr={"bg_color": "#80cbc4", "label": "Public Subnet (10.0.1.0/24)"}):
                    ec2 = EC2("Web Server\n(App + Docker)")
                    
                # ربط السيرفر بالشبكة
                ec2 >> Edge(label="Internet Traffic", color="blue") >> igw

    # إنشاء الاتصالات من العناصر الخارجية
    # (تمت إضافة لون وشكل مختلف لسهولة القراءة)
    igw >> Edge(color="blue", style="dashed") >> ec2
    tf >> Edge(color="orange", style="dotted", label="Provision via IaC") >> ec2