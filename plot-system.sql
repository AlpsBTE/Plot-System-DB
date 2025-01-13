CREATE SCHEMA plotsystem_v2;

CREATE TABLE IF NOT EXISTS plotsystem_v2.system_info (
    system_id INT NOT NULL AUTO_INCREMENT,
    db_version DOUBLE NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    description TEXT NULL,
    PRIMARY KEY (system_id)
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.build_team
(
    build_team_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    api_key VARCHAR(255) NULL UNIQUE,
    api_create_date DATETIME NULL,
    PRIMARY KEY (build_team_id)
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.server
(
    build_team_id INT NOT NULL,
    server_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (build_team_id, server_name),
    FOREIGN KEY (build_team_id) REFERENCES plotsystem_v2.build_team(build_team_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.country
(
    country_code VARCHAR(2) NOT NULL,
    continent ENUM('EU','AS','AF','OC','SA','NA') NOT NULL,
    material VARCHAR(255) NOT NULL,
    custom_model_data VARCHAR(255) NULL,
    PRIMARY KEY (country_code)
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.city_project
(
    city_project_id VARCHAR(255) NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    server_name VARCHAR(255) NOT NULL,
    is_visible TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (city_project_id),
    FOREIGN KEY (country_code) REFERENCES plotsystem_v2.country(country_code)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (server_name) REFERENCES plotsystem_v2.server(server_name)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.builder
(
    uuid VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    score INT NOT NULL DEFAULT 0,
    first_slot INT NULL,
    second_slot INT NULL,
    third_slot INT NULL,
    plot_type INT NOT NULL,
    PRIMARY KEY (uuid)
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.plot_difficulty
(
    difficulty_id VARCHAR(255) NOT NULL,
    multiplier DECIMAL(4,2) DEFAULT 1.00,
    score_requirement INT NOT NULL DEFAULT 0,
    PRIMARY KEY (difficulty_id),
    CHECK ( multiplier > 0 ),
    CHECK ( score_requirement >= 0 )
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.plot
(
    plot_id INT NOT NULL AUTO_INCREMENT,
    city_project_id VARCHAR(255) NOT NULL,
    difficulty_id VARCHAR(255) NOT NULL,
    status ENUM('unclaimed','unfinished','unreviewed','completed') NOT NULL DEFAULT 'unclaimed',
    score INT NULL,
    outline_bounds TEXT NOT NULL,
    initial_schematic MEDIUMBLOB NOT NULL,
    complete_schematic MEDIUMBLOB NULL,
    last_activity_date DATETIME NULL,
    is_pasted TINYINT NOT NULL DEFAULT 0,
    mc_version VARCHAR(8) NULL,
    plot_version DOUBLE NOT NULL,
    created_by VARCHAR(36) NOT NULL,
    create_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (plot_id),
    FOREIGN KEY (city_project_id) REFERENCES plotsystem_v2.city_project(city_project_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (difficulty_id) REFERENCES plotsystem_v2.plot_difficulty(difficulty_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.tutorial
(
    tutorial_id INT NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    stage_id INT NOT NULL,
    is_complete TINYINT NOT NULL DEFAULT 0,
    first_stage_start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_stage_complete_date DATETIME NULL,
    PRIMARY KEY (tutorial_id, uuid)
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.plot_review
(
    review_id INT NOT NULL,
    plot_id INT NOT NULL,
    rating VARCHAR(7) NOT NULL,
    feedback VARCHAR(256) NULL,
    reviewed_by VARCHAR(36) NOT NULL,
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id),
    FOREIGN KEY (plot_id) REFERENCES plotsystem_v2.plot(plot_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.build_team_has_country
(
    build_team_id INT NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    PRIMARY KEY (build_team_id, country_code),
    FOREIGN KEY (build_team_id) REFERENCES plotsystem_v2.build_team(build_team_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (country_code) REFERENCES plotsystem_v2.country(country_code)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.build_team_has_city_project
(
    build_team_id INT NOT NULL,
    city_project_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (build_team_id, city_project_id),
    FOREIGN KEY (build_team_id) REFERENCES plotsystem_v2.build_team(build_team_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (city_project_id) REFERENCES plotsystem_v2.city_project(city_project_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.build_team_has_reviewer
(
    build_team_id INT NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    PRIMARY KEY (build_team_id, uuid),
    FOREIGN KEY (build_team_id) REFERENCES plotsystem_v2.build_team(build_team_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (uuid) REFERENCES plotsystem_v2.builder(uuid)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.builder_has_review_notification
(
    review_id INT NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    PRIMARY KEY (review_id, uuid),
    FOREIGN KEY (review_id) REFERENCES plotsystem_v2.plot_review(review_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (uuid) REFERENCES plotsystem_v2.builder(uuid)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS plotsystem_v2.builder_has_plot
(
    plot_id INT NOT NULL,
    uuid VARCHAR(36) NOT NULL,
    is_owner TINYINT NOT NULL,
    PRIMARY KEY (plot_id, uuid),
    FOREIGN KEY (plot_id) REFERENCES plotsystem_v2.plot(plot_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (uuid) REFERENCES plotsystem_v2.builder(uuid)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO plotsystem_v2.system_info (system_id, db_version, description)
    VALUES (1, 2.0, 'Initial database schema for Plot-System v5.0');

INSERT INTO plotsystem_v2.plot_difficulty (difficulty_id, multiplier)
    VALUES ('EASY', 1.0),
           ('MEDIUM', 1.5),
           ('HARD', 2);