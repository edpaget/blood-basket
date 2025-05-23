
-- Create the combined app_authorization table
CREATE TABLE app_authorization (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), -- Session/Authorization ID
    actor_id TEXT NOT NULL,                       -- Link to the actor
    provider identity_strategy NOT NULL,          -- Identity provider (e.g., 'SIGN_IN_WITH_GOOGLE', 'local')
    provider_identity TEXT NOT NULL,              -- User's ID from the provider
    created_at TIMESTAMPTZ NOT NULL DEFAULT get_current_timestamp(), -- Changed type and default
    expires_at TIMESTAMPTZ,                       -- Changed type

    -- Define the foreign key to the actor table
    CONSTRAINT fk_app_authorization_actor
        FOREIGN KEY (actor_id)
        REFERENCES actor(id)
        ON DELETE CASCADE, -- If an actor is deleted, remove the authorization

    -- Define the foreign key to the identity table
    CONSTRAINT fk_app_authorization_identity
        FOREIGN KEY (provider, provider_identity)
        REFERENCES identity(provider, provider_identity)
        ON DELETE CASCADE -- If an identity is deleted, remove the authorization
);

-- Index for lookups by actor_id
CREATE INDEX idx_app_authorization_actor_id ON app_authorization(actor_id);
-- Index for lookups by identity
CREATE INDEX idx_app_authorization_identity ON app_authorization(provider, provider_identity);
