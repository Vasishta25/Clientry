/*
  # Add user_id and Update RLS Policies

  1. Changes
    - Add user_id column to companies table
    - Update RLS policies to properly handle user ownership

  2. Security
    - Modify policies to check user ownership
    - Ensure authenticated users can only access their own data
*/

-- Add user_id column to companies
ALTER TABLE companies 
ADD COLUMN user_id UUID NOT NULL DEFAULT auth.uid();

-- Drop existing policies
DROP POLICY IF EXISTS "Users can read own company data" ON companies;
DROP POLICY IF EXISTS "Users can insert company data" ON companies;

-- Create new policies with proper ownership checks
CREATE POLICY "Users can read own company data"
ON companies
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own company data"
ON companies
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);