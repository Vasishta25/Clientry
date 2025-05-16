/*
  # Initial Schema Setup for Clientry

  1. New Tables
    - companies
      - id (uuid, primary key)
      - name (text)
      - created_at (timestamp)
    - team_members
      - id (uuid, primary key)
      - company_id (uuid, foreign key)
      - name (text)
      - email (text)
      - designation (text)
      - assigned_under (uuid, self-referential)
      - created_at (timestamp)
    - clients
      - id (uuid, primary key)
      - company_id (uuid, foreign key)
      - name (text)
      - email (text)
      - created_at (timestamp)
    - client_members
      - id (uuid, primary key)
      - client_id (uuid, foreign key)
      - member_id (uuid, foreign key)
      - created_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Companies table
CREATE TABLE companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Team members table
CREATE TABLE team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid REFERENCES companies(id),
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  designation text NOT NULL,
  assigned_under uuid REFERENCES team_members(id),
  created_at timestamptz DEFAULT now()
);

-- Clients table
CREATE TABLE clients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid REFERENCES companies(id),
  name text NOT NULL,
  email text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Client members junction table
CREATE TABLE client_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id uuid REFERENCES clients(id),
  member_id uuid REFERENCES team_members(id),
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_members ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can read own company data"
  ON companies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert company data"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can read team members"
  ON team_members
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert team members"
  ON team_members
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can read clients"
  ON clients
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert clients"
  ON clients
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Users can read client members"
  ON client_members
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert client members"
  ON client_members
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Insert dummy data
INSERT INTO companies (name) VALUES
  ('Sample CA Firm');

INSERT INTO team_members (company_id, name, email, designation) VALUES
  ((SELECT id FROM companies LIMIT 1), 'John Doe', 'john@example.com', 'CA Partner'),
  ((SELECT id FROM companies LIMIT 1), 'Jane Smith', 'jane@example.com', 'Audit Assistant');

INSERT INTO clients (company_id, name, email) VALUES
  ((SELECT id FROM companies LIMIT 1), 'Client Company 1', 'client1@example.com'),
  ((SELECT id FROM companies LIMIT 1), 'Client Company 2', 'client2@example.com');

INSERT INTO client_members (client_id, member_id) VALUES
  ((SELECT id FROM clients WHERE name = 'Client Company 1' LIMIT 1),
   (SELECT id FROM team_members WHERE name = 'John Doe' LIMIT 1)),
  ((SELECT id FROM clients WHERE name = 'Client Company 2' LIMIT 1),
   (SELECT id FROM team_members WHERE name = 'Jane Smith' LIMIT 1));