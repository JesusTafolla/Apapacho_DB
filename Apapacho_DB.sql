CREATE TABLE `Etiquetas` (
  `Alianzas` integer,
  `Coyametla` integer,
  `Gesha` integer,
  `Marragogype` integer,
  `Resiliente` integer,
  `Purpura` integer,
  `Perfilados` integer,
  `Fundadora` integer,
  `Varias_Fincas` integer,
  `created_at` timestamp
);

CREATE TABLE `Insumos` (
  `Etiquetas_id` varchar(255),
  `Bolsas_id` varchar(255),
  `Cajas_id` varchar(255),
  `Filtros_id` varchar(255),
  `Insumos_Varios_Id` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `Bolsas` (
  `Bolsa_Plastico_3000` integer,
  `Bolsa_Plastico_5000` integer,
  `Bolsa_Papel_1000` integer,
  `Bolsa_Papel_500` integer,
  `Bolsa_Papel_250` integer,
  `created_at` timestamp
);

CREATE TABLE `Apapabho_DB` (
  `id` integer PRIMARY KEY,
  `Etiquetas` varchar(255),
  `Bolsas` varchar(255),
  `Cajas` varchar(255),
  `Filtros` varchar(255),
  `Insumos_varios` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `Cajas` (
  `Caja_Chica` integer,
  `Caja_Mediana` integer,
  `Caja_Grande` integer,
  `Caja_Impresa` integer
);

CREATE TABLE `Filtros` (
  `V60` integer,
  `Chemex` integer,
  `Kalita` integer,
  `Aeropress` integer,
  `Pulsar` integer,
  `Tody` integer
);

CREATE TABLE `Insumos_Varios` (
  `Tiritas_5` integer,
  `Tiritas_7` integer,
  `Sticker_1` integer,
  `Sticker_2` integer,
  `Postales_1` integer,
  `Postales_2` integer,
  `Separadores_1` integer,
  `Separadores_2` integer,
  `Papel_Albanene` integer,
  `Papeleria_Insumos` varchar(255),
  `Insumos_Banio` varchar(255),
  `Botella_CB_1000` integer,
  `Botella_CB_250` integer,
  `Tapas_CB` integer,
  `Etiquetas_CB_1000` integer,
  `Etiquetas_CB_250` integer
);

ALTER TABLE `Apapabho_DB` ADD FOREIGN KEY (`Bolsas`) REFERENCES `Insumos` (`Bolsas_id`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Bolsas_id`) REFERENCES `Bolsas` (`Bolsa_Papel_250`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Bolsas_id`) REFERENCES `Bolsas` (`Bolsa_Papel_1000`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Bolsas_id`) REFERENCES `Bolsas` (`Bolsa_Papel_500`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Bolsas_id`) REFERENCES `Bolsas` (`Bolsa_Plastico_3000`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Bolsas_id`) REFERENCES `Bolsas` (`Bolsa_Plastico_5000`);

ALTER TABLE `Apapabho_DB` ADD FOREIGN KEY (`Etiquetas`) REFERENCES `Insumos` (`Etiquetas_id`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Alianzas`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Coyametla`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Fundadora`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Gesha`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Marragogype`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Perfilados`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Purpura`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Resiliente`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Etiquetas_id`) REFERENCES `Etiquetas` (`Varias_Fincas`);

ALTER TABLE `Apapabho_DB` ADD FOREIGN KEY (`Cajas`) REFERENCES `Insumos` (`Cajas_id`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Cajas_id`) REFERENCES `Cajas` (`Caja_Chica`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Cajas_id`) REFERENCES `Cajas` (`Caja_Grande`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Cajas_id`) REFERENCES `Cajas` (`Caja_Impresa`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Cajas_id`) REFERENCES `Cajas` (`Caja_Mediana`);

ALTER TABLE `Apapabho_DB` ADD FOREIGN KEY (`Filtros`) REFERENCES `Insumos` (`Filtros_id`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`Aeropress`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`Chemex`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`Kalita`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`Pulsar`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`Tody`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Filtros_id`) REFERENCES `Filtros` (`V60`);

ALTER TABLE `Apapabho_DB` ADD FOREIGN KEY (`Insumos_varios`) REFERENCES `Insumos` (`Insumos_Varios_Id`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Insumos_Banio`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Papel_Albanene`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Papeleria_Insumos`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Postales_1`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Postales_2`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Separadores_1`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Separadores_2`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Sticker_1`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Sticker_2`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Tiritas_5`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Tiritas_7`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Botella_CB_1000`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Botella_CB_250`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Etiquetas_CB_250`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Etiquetas_CB_1000`);

ALTER TABLE `Insumos` ADD FOREIGN KEY (`Insumos_Varios_Id`) REFERENCES `Insumos_Varios` (`Tapas_CB`);
