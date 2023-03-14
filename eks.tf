resource "aws_eks_cluster" "Alt-eks" {
  name     = "Alt-eks"
  role_arn = aws_iam_role.eks_cluster-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.eks_private_subnet_1.id, aws_subnet.eks_private_subnet_2.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster-policy]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster-role" {
  name = "eks_cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an IAM policy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster-role.name
}

# Create the worker node group
resource "aws_eks_node_group" "Eks-node_group" {
  cluster_name    = aws_eks_cluster.Alt-eks.name
  node_group_name = "example-node-group"

  node_role_arn = aws_iam_role.eks_node_group-role.arn
  instance_types  = ["t3.medium"] 
  
  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 4
  }

  remote_access {
    ec2_ssh_key = "project"
    source_security_group_ids = [aws_security_group.eks_sg.id]
  }

  subnet_ids = [aws_subnet.eks_private_subnet_1.id, aws_subnet.eks_private_subnet_2.id]

  depends_on = [aws_iam_role_policy_attachment.eks_node_group-policy]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create an IAM role for the worker nodes
resource "aws_iam_role" "eks_node_group-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an IAM policy to the worker node role
resource "aws_iam_role_policy_attachment" "eks_node_group-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group-role.name
}

#Attach additional IAM policies to the worker node role if needed
resource "aws_iam_role_policy_attachment" "eks_node_group_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
 role       = aws_iam_role.eks_node_group-role.name
}



resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role        = aws_iam_role.eks_node_group-role.name
}


