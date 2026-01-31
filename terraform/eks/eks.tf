###
# cluster
###
resource "aws_eks_cluster" "this" {
  name     = "henry-practice"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.33"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
    endpoint_public_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

###
# node group
###
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "henry-practice-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = ["t3.medium"]
  launch_template {
    id      = aws_launch_template.node_group_launch_template.id
    version = "$Latest"
  }

  scaling_config {
    max_size     = 3
    desired_size = 2
    min_size     = 2
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
    aws_iam_role_policy_attachment.eks_ssm_policy,
    aws_iam_role_policy_attachment.eks_bedrock_policy
  ]
}

resource "aws_launch_template" "node_group_launch_template" {
  name = "node-group-launch-template"

  vpc_security_group_ids = [aws_security_group.node_group_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "henry-practice-node-group-launch-template"
    }
  }
}

resource "aws_security_group" "node_group_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "node-group-sg"
  }
}

# from GPT
###
# Node → Cluster (Node SG 流量進 Cluster SG)
###
resource "aws_security_group_rule" "node_to_cluster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.node_group_sg.id
  description              = "Allow nodes to communicate with control plane"
}

###
# Cluster → Node (Cluster SG 流量進 Node SG)
###
resource "aws_security_group_rule" "cluster_to_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.node_group_sg.id
  source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description              = "Allow control plane to communicate with nodes"
}
