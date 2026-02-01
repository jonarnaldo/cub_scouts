CREATE TYPE scout_rank AS ENUM (
  'Lion', 
  'Tiger', 
  'Wolf', 
  'Bear', 
  'Webelos', 
  'Arrow of Light'
);

CREATE TABLE dens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL, -- e.g., 'Den 4'
  rank_level scout_rank NOT NULL
);

CREATE TABLE scouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  parent_email TEXT
);

CREATE TABLE den_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scout_id UUID REFERENCES scouts(id) ON DELETE CASCADE,
  den_id UUID REFERENCES dens(id),
  joined_at DATE DEFAULT CURRENT_DATE,
  left_at DATE,
  is_active BOOLEAN DEFAULT true
);

CREATE TABLE positions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL, -- 'Den Leader', 'Treasurer', 'Committee Chair'
  is_den_specific BOOLEAN DEFAULT false
);

CREATE TABLE leader_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  position_id UUID REFERENCES positions(id),
  den_id UUID REFERENCES dens(id), -- NULL for Pack-wide roles (Treasurer, etc)
  is_active BOOLEAN DEFAULT true
);

CREATE TABLE achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  rank_level scout_rank NOT NULL,
  is_elective BOOLEAN DEFAULT false
);

CREATE TABLE scout_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scout_id UUID REFERENCES scouts(id) ON DELETE CASCADE,
  achievement_id UUID REFERENCES achievements(id),
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  recorded_by UUID REFERENCES auth.users(id)
);