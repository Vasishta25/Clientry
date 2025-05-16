export interface Company {
  id: string;
  name: string;
  created_at: string;
}

export interface TeamMember {
  id: string;
  company_id: string;
  name: string;
  email: string;
  designation: string;
  assigned_under?: string;
  created_at: string;
}

export interface Client {
  id: string;
  company_id: string;
  name: string;
  email: string;
  created_at: string;
}

export interface ClientMember {
  id: string;
  client_id: string;
  member_id: string;
  created_at: string;
}