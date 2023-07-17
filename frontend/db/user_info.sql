CREATE TABLE user_info (
    user_id SERIAL PRIMARY KEY,
    location INTEGER[],
    occupation_pref INTEGER[],
    ideal_date_pref INTEGER[],
    ideal_date_pref_other_selected BOOLEAN,
    ideal_date_pref_other_desc VARCHAR(75),
    ethnicity_pref INTEGER[],
    min_age_pref INTEGER,
    max_age_pref INTEGER
);