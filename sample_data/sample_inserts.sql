INSERT INTO plotsystem_v2.build_team (build_team_id, name, api_key, api_create_date)
    VALUES (1, 'Alps BTE', '331f5acc-9ce7-4fee-aef8-d0c535251c69', CURRENT_TIMESTAMP()),
           (2, 'BTE Germany', null, null);

INSERT INTO plotsystem_v2.server (build_team_id, server_name)
    VALUES (1, 'ALPS-1'),
           (2, 'GER-1');

INSERT INTO plotsystem_v2.country (country_code, continent, material)
    VALUES ('AT', 'EU', 'SKELETON_SKULL'),
           ('CH', 'EU', 'SKELETON_SKULL'),
           ('LI', 'EU', 'SKELETON_SKULL'),
           ('DE', 'EU', 'SKELETON_SKULL');

INSERT INTO plotsystem_v2.city_project (city_project_id, country_code, server_name)
    VALUES ('VIENNA_SUBURBS', 'AT', 'ALPS-1'),
           ('ZURICH_SUBURBS', 'CH', 'ALPS-1'),
           ('MUNICH_SUBURBS', 'DE', 'GER-1');

INSERT INTO plotsystem_v2.build_team_has_city_project (build_team_id, city_project_id)
    VALUES (1, 'VIENNA_SUBURBS'),
           (1, 'ZURICH_SUBURBS'),
           (2, 'MUNICH_SUBURBS');

INSERT INTO plotsystem_v2.builder (uuid, name, plot_type)
    VALUES ('3b350308-d857-4ecc-8b71-c93a2cf3c87b', 'R3tuxn', 1);

INSERT INTO plotsystem_v2.build_team_has_reviewer (build_team_id, uuid)
    VALUES (1, '3b350308-d857-4ecc-8b71-c93a2cf3c87b');