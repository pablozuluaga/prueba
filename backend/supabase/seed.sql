-- Generado por tools/generar_seed.py a partir de assets/carta.json. No editar a mano.

begin;

delete from public.productos;
delete from public.categorias;

update public.config set nombre = 'Crepes & Waffles' where id = 1;

with c as (insert into public.categorias (nombre, nota, orden) values ('HUEVOS', null, 0) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'huevos--poche', 'Poché', 'Gratinados con el toque especial de Crepes & Waffles®.', 13300, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'huevos--benedictine', 'Benedictine', 'Sobre un muffin inglés con lomo ahumado de cerdo y salsa Crepes & Waffles®.', 25900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'huevos--rancheros', 'Rancheros', 'Huevos con cebolla, lomo ahumado de cerdo, salsa de tomate y queso parmesano.', 21500, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'huevos--australianos', 'Australianos', 'Huevos poché, corte especial de tocineta, aguacate, tomate asado y salsa poché, todo sobre una tostada de pan artesanal.', 29800, '[]'::jsonb, array[]::text[], 'reales/plato-huevos-australianos.png', 3),
  ((select id from c), 'huevos--crepes-waffles', 'Crepes & Waffles®', 'Crepe con huevos revueltos y cebollina a la crema sobre un fondo de salsa de queso.', 17900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'huevos--rosarito', 'Rosarito', 'Tostada artesanal, dos huevos poché, tocineta crujiente, aguacate y una salsa de chile chipotle resaltando el sabor de México.', 28900, '[]'::jsonb, array[]::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES', 'masa vegana y sin gluten. Ahora puedes pedir tus crepes en', 1) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes--sensacion-colombia', 'Sensación Colombia', 'Carne desmechada, queso, huevo, crema agria y nuestro tradicional “hogao".', 28900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes--jamon-y-queso', 'Jamón y Queso', null, 19900, '[]'::jsonb, array[]::text[], 'reales/plato-crepe-jamon-y-queso.png', 1),
  ((select id from c), 'crepes--queso', 'Queso', null, 14200, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes--parisien', 'Parisien', 'Crepe con huevo, tocineta, queso y salsa de queso.', 24900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes--bretonne', 'Bretonne', 'Típica crepe francesa de lomo ahumado de cerdo, queso y huevo.', 25900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'crepes--crespolinis', 'Crespolinis', 'Crepe con huevos revueltos, lomo ahumado de cerdo, queso y salsa primavera.', 22900, '[]'::jsonb, array[]::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('WAFFLES', null, 2) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'waffles--mantequilla-y-syrup-o-miel', 'Mantequilla y Syrup o Miel', 'Pídelos  también con :', 11200, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'waffles--huevo-frito-y-tocineta', 'Huevo Frito y Tocineta', null, 18400, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'waffles--huevo-frito-y-salchichas', 'Huevo Frito y Salchichas', null, 18400, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'waffles--waffle-d-choclo', 'Waffle D’Choclo', 'Waffle de maíz relleno de queso, con queso 7 cueros y suero costeño.', 16500, '[]'::jsonb, array[]::text[], null, 3);

with c as (insert into public.categorias (nombre, nota, orden) values ('MINI WAFFLES', null, 3) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'mini-waffles--mini-waffle-d-yuca', 'Mini Waffle D''Yuca', 'Un mini waffle con mantequilla, panela orgánica molida y jalea de guayaba.', 8900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'mini-waffles--pidelo-con-doble-mini-waffles', 'Pídelo con doble Mini Waffles', null, 15900, '[]'::jsonb, array[]::text[], null, 1);

with c as (insert into public.categorias (nombre, nota, orden) values ('MENÚ INFANTIL', null, 4) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'menu-infantil--waffle-mickey-con', 'Waffle Mickey con:', null, 14900, '[{"nombre": "Syrup, Salchichitas y Huevo Frito", "precio": 14900}, {"nombre": "Syrup, Tocineta y Huevo Frito", "precio": 14900}]'::jsonb, array[]::text[], null, 0);

with c as (insert into public.categorias (nombre, nota, orden) values ('+ OPCIONES', null, 5) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'opciones--timbal-de-frutas-frescas', 'Timbal de Frutas Frescas', 'Refrescante combinación de mango, sandía y naranja.', 9900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'opciones--acai-bowl', 'Açaí Bowl', 'Açaí con arándanos, fresa, banano y granola.', 21900, '[]'::jsonb, array[]::text[], 'reales/plato-acai-bowl.png', 1),
  ((select id from c), 'opciones--pancakes-de-ahuyama', 'Pancakes de Ahuyama', 'Con yogurt griego, granola y miel.', 18900, '[]'::jsonb, array[]::text[], 'reales/plato-pancakes-de-ahuyama.png', 2),
  ((select id from c), 'opciones--frutos-del-bosque', 'Frutos del Bosque', 'Copa con granola, yogurt de vainilla, fresa, arándanos y salsa de arándanos.', 19400, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'opciones--guanabana', 'Guanábana', 'Copa de yogurt griego natural sin azúcar, acompañado de granola y copos de guanábana... Endulza a tu gusto con miel.', 19400, '[]'::jsonb, array[]::text[], null, 4);

with c as (insert into public.categorias (nombre, nota, orden) values ('PARA CADA DÍA', null, 6) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'para-cada-dia--queso-momposino', 'Queso Momposino', 'Tradicional y delicioso queso en capas de Mompox para que estires a tu antojo.', 16900, '[]'::jsonb, array[]::text[], null, 0);

with c as (insert into public.categorias (nombre, nota, orden) values ('JUGOS', null, 7) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'jugos--mora', 'Mora', null, 7900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'jugos--mango', 'Mango', null, 8200, '[]'::jsonb, array[]::text[], 'reales/plato-jugo-de-mango.png', 1),
  ((select id from c), 'jugos--mandarina', 'Mandarina', null, 10200, '[]'::jsonb, array[]::text[], 'reales/plato-jugo-de-mandarina.png', 2),
  ((select id from c), 'jugos--fresa', 'Fresa', null, 8300, '[]'::jsonb, array[]::text[], 'reales/plato-jugo-de-fresa.png', 3),
  ((select id from c), 'jugos--guanabana', 'Guanábana', 'Jugo natural en leche.', 8500, '[]'::jsonb, array[]::text[], 'reales/plato-jugo-de-guanabana.png', 4),
  ((select id from c), 'jugos--naranja', 'Naranja', null, 9600, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'jugos--frambuesa', 'Frambuesa', null, 10500, '[]'::jsonb, array[]::text[], null, 6);

with c as (insert into public.categorias (nombre, nota, orden) values ('LIMONADAS', null, 8) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'limonadas--natural', 'Natural', null, 6900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'limonadas--hierbabuena', 'Hierbabuena', null, 8300, '[]'::jsonb, array[]::text[], 'reales/plato-limonada-hierbabuena.png', 1),
  ((select id from c), 'limonadas--mango-biche', 'Mango Biche', null, 9600, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'limonadas--coco', 'Coco', null, 11600, '[]'::jsonb, array[]::text[], null, 3);

with c as (insert into public.categorias (nombre, nota, orden) values ('BATIDOS', null, 9) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'batidos--pina-jengibre-y-hierbabuena', 'Piña, Jengibre y Hierbabuena', null, 9900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'batidos--alegria', 'Alegría', 'Mezcla de frutas del campo: mango, maracuyá y piña.', 11200, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'batidos--bienestar', 'Bienestar', 'Mezcla de frutas del campo: manzana, pera, feijoa y hierbabuena.', 11200, '[]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('OTRAS BEBIDAS', null, 10) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'otras-bebidas--agua-siembra-con-o-sin-gas', 'Agua Siembra® con o sin Gas', null, 7500, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'otras-bebidas--agua-manantial', 'Agua Manantial®', null, 7500, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'otras-bebidas--agua-manantial-con-gas', 'Agua Manantial® con Gas', null, 7200, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'otras-bebidas--coca-cola', 'Coca-Cola®', 'Original o Zero.', 6500, '[]'::jsonb, array[]::text[], null, 3);

with c as (insert into public.categorias (nombre, nota, orden) values ('ENTRADAS', null, 11) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'entradas--ensalada-de-la-barra', 'Ensalada de la Barra', 'Porque nadie conoce la mezcla mejor que tú.', 18900, '[]'::jsonb, array[]::text[], 'reales/plato-ensalada-de-la-barra.png', 0),
  ((select id from c), 'entradas--ensalada-cesar', 'Ensalada Cesar', null, 17900, '[]'::jsonb, array[]::text[], null, 1);

with c as (insert into public.categorias (nombre, nota, orden) values ('SOPAS', null, 12) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'sopas--soy-otono', 'Soy Otoño', 'Explosión de vegetales, tomate, zucchini y zanahoria, con frijolitos rojos cuarentanos. *Frijol de temporada, origen Montes de María.', 11900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'sopas--espinaca', 'Espinaca', 'Sopa de espinaca del huerto a tu casa. Naturalmente deliciosa.', 13900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'sopas--lentejas', 'Lentejas', 'Con champiñones y Portobellos, lentejas beluga y un ligero toque de especias de la India.', 14900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'sopas--covarachia', 'Covarachía', 'Sopa donde el tomate, el maíz y el plátano entran a jugar para resaltar el valor de los sabores de nuestra tierra, con aguacate, crema agria y cilantro.', 15900, '[]'::jsonb, array[]::text[], 'reales/plato-sopa-covarachia.png', 3),
  ((select id from c), 'sopas--sopa-del-sol', 'Sopa del Sol', 'Sopa de zapallo con un toque de queso de cabra y pesto, pan pita y cilantro.', 14900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'sopas--mexicana-con-pollo', 'Mexicana con Pollo', 'Sabores de México: chile chipotle, crema agria, queso, aguacate, pollo, pico de gallo y tortilla mexicana.', 20500, '[]'::jsonb, array[]::text[], 'reales/plato-sopa-mexicana-con-pollo.png', 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES CLÁSICOS', null, 13) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-clasicos--jamon-y-queso', 'Jamón y Queso', 'Puedes pedirlo también con:', 19900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-clasicos--champinones', 'Champiñones', '1', 23900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-clasicos--pavo-queso-tipo-holandes-y-salsa-dijonnaise', 'Pavo, Queso tipo Holandés y Salsa Dijonnaise', null, 31900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-clasicos--sensacion', 'Sensación', 'Lomo ahumado de cerdo, queso y huevo. Pídelo también con cebolla y tomate.', 25900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes-clasicos--sensacion-colombia', 'Sensación Colombia', 'Carne desmechada, queso, huevo, crema agria y nuestro tradicional “hogao".', 28900, '[]'::jsonb, array[]::text[], null, 4);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES VEGETARIANOS', null, 14) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-vegetarianos--champinones-al-ajillo', 'Champiñones al Ajillo', 'Crepe de champiñones en salsa al ajillo con queso. 1', 22900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-vegetarianos--romana', 'Romana', 'Mozzarellina, salsa napolitana con albahaca y queso parmesano. 1', 22900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-vegetarianos--sicilia', 'Sicilia', 'Mozzarellina, tomates secos, tomates frescos y albahaca.', 25400, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-vegetarianos--champinones-alcachofa-y-queso', 'Champiñones, Alcachofa y Queso', null, 27900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes-vegetarianos--poblana', 'Poblana', 'Aguacate, queso, pico de gallo, salsa agria, lechuga y un delicioso toque mexicano de ají.', 25900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'crepes-vegetarianos--toscana', 'Toscana', 'Queso, tomate, albahaca, champiñones frescos, salsa de champiñones y napolitana.', 25900, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'crepes-vegetarianos--normanda', 'Normanda', 'Champiñones frescos, variedad de quesos y salsa de champiñones.', 26900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'crepes-vegetarianos--caprino', 'Caprino', 'Champiñones salteados, tomates secos, tomates frescos, pesto, reducción de balsámico y mozzarellina.', 29800, '[]'::jsonb, array[]::text[], null, 7);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES DE CARNE', null, 15) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-de-carne--bolonesa-y-queso', 'Boloñesa y Queso', 'Puedes pedirlo también con:', 23300, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-de-carne--lomo-ahumado-de-cerdo', 'Lomo Ahumado de Cerdo', null, 26900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-de-carne--champinones', 'Champiñones', null, 25900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-de-carne--sombrero-vueltiao', 'Sombrero Vueltiao', 'Carne desmechada, preparada con “hogao” sobre puré de plátano maduro, acompañada de crema agria, aguacate y un toque de pico de gallo.', 30900, '[]'::jsonb, array[]::text[], 'reales/plato-sombrero-vueltiao.png', 3),
  ((select id from c), 'crepes-de-carne--cochinita-pibil', 'Cochinita Pibil', 'Preparación mexicana de cerdo desmechado, acompañado de tonos cítricos y un toque de aguacate, lechuga, pico de gallo, cebolla encurtida y crema agria.', 29600, '[]'::jsonb, array[]::text[], 'reales/plato-cochinita-pibil.png', 4),
  ((select id from c), 'crepes-de-carne--ternera', 'Ternera', 'Puedes pedirlo también con:', 31500, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'crepes-de-carne--champinones-2', 'Champiñones', null, 31800, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'crepes-de-carne--stroganoff', 'Stroganoff', 'Julianas de lomo y champiñones en su salsa.', 37200, '[]'::jsonb, array[]::text[], null, 7),
  ((select id from c), 'crepes-de-carne--mexicano', 'Mexicano', 'Boloñesa en salsa mexicana, queso rallado, lechuga, crema agria, ají y pico de gallo.', 28900, '[]'::jsonb, array[]::text[], null, 8),
  ((select id from c), 'crepes-de-carne--lomito-pimienta', 'Lomito Pimienta', 'Julianas de lomo y pimienta del Putumayo en su salsa.', 38200, '[]'::jsonb, array[]::text[], null, 9),
  ((select id from c), 'crepes-de-carne--roastbeef', 'Roastbeef', 'Tajadas de roastbeef y queso, cebollas asadas, rúgula, mayonesa chipotle y chucrut de cebollas, armando una fantasía de sabor.', 34900, '[]'::jsonb, array[]::text[], null, 10),
  ((select id from c), 'crepes-de-carne--lomo-arabe', 'Lomo Árabe', 'Con especias del Medio Oriente y ensalada a su mejor estilo.', 41800, '[]'::jsonb, array[]::text[], null, 11);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES DE POLLO', null, 16) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-de-pollo--pollo-y-queso', 'Pollo y Queso', 'Puedes pedirlo también con:', 27900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-de-pollo--champinones', 'Champiñones', null, 30900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-de-pollo--brocoli-y-salsa-de-queso-parmesano', 'Brócoli y Salsa de Queso Parmesano', null, 33600, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-de-pollo--pollo-al-curry', 'Pollo al Curry', null, 30900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes-de-pollo--pollo-chipotle', 'Pollo Chipotle', 'Pollo con salsa chipotle, aguacate, pico de gallo, queso, maíz y crema agria, acompañado de rúgula.', 31900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'crepes-de-pollo--pollo-rosarito', 'Pollo Rosarito', 'Pollo en salsa mexicana con chipotle, arcos de aguacate y frijol rojo cuarentano. *Frijol de temporada, origen Montes de María.', 32800, '[]'::jsonb, array[]::text[], 'reales/plato-pollo-rosarito.png', 5),
  ((select id from c), 'crepes-de-pollo--pollo-al-curry-al-estilo-hindu', 'Pollo al Curry al estilo Hindú', 'Con maní, uvas pasas y chutney de mango.', 31900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'crepes-de-pollo--pollo-trufa-mexicano', 'Pollo Trufa Mexicano', 'Mezcla de sabores mexicanos con huitlacoche, aguacate y salsa de queso parmesano.', 32900, '[]'::jsonb, array[]::text[], null, 7),
  ((select id from c), 'crepes-de-pollo--pollo-peruano', 'Pollo Peruano', 'Típica preparación de ají de gallina limeño,salsa de aceitunas y aceitunas moradas, rúgula y huevo.', 31900, '[]'::jsonb, array[]::text[], null, 8),
  ((select id from c), 'crepes-de-pollo--pollo-al-aji-panka', 'Pollo al Ají Panka', 'Pollo con todos los sabores del Perú. Puré de frijol al cilantro, aguacate, rúgula, filamentos de pimentón y cebolla roja.', 32900, '[]'::jsonb, array[]::text[], null, 9),
  ((select id from c), 'crepes-de-pollo--pollo-mexicano', 'Pollo Mexicano', 'Pollo en salsa mexicana y chipotle, queso rallado, lechuga, crema agria, ají y pico de gallo.', 32500, '[]'::jsonb, array[]::text[], null, 10),
  ((select id from c), 'crepes-de-pollo--pollo-thai', 'Pollo Thai', 'Pechuga de pollo y champiñones Portobello, con una mezcla de sabores orientales a base de curry y maracuyá.', 33500, '[]'::jsonb, array[]::text[], null, 11);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES DE MAR', null, 17) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-de-mar--palmitos', 'Palmitos', 'Al Curry, al Ajillo o en Salsa de la Casa . (Marco Polo)', 32300, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-de-mar--calamares', 'Calamares', 'Al Curry, al Ajillo o en Salsa de la Casa . (Marco Polo)', 34800, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-de-mar--camarones', 'Camarones', 'Al Curry, al Ajillo o en Salsa de la Casa . (Marco Polo)', 41900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-de-mar--mar-encocado', 'Mar Encocado', 'Pulpo, camarones, calamares y langostinos sobre quinua negra, bañados en salsa de coco y toques de coco crujiente.', 42500, '[]'::jsonb, array[]::text[], 'reales/plato-mar-encocado.png', 3),
  ((select id from c), 'crepes-de-mar--camarones-rosarito', 'Camarones Rosarito', 'En salsa mexicana con chipotle, arcos de aguacate y frijol rojo cuarentano. *Frijol de temporada, origen Montes de María.', 42800, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'crepes-de-mar--salmon-roll', 'Salmon Roll', 'Rollitos de salmón ahumado con rúgula, queso crema, mostaza, cebolla, aguacate y crujientes vegetales frescos. Acompañados de ensalada verde. 1 Pídelo con ensalada verde, vinagre balsámico y aceite de oliva. Valor adicional: $6.400', 42500, '[]'::jsonb, array[]::text[], 'reales/plato-salmon-roll.png', 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('PITAS', null, 18) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'pitas--pollo-arabe', 'Pollo Árabe', 'Pechuga de pollo al horno, lechuga, tahini, trocitos de aceitunas y cebollas encurtidas. 1', 28900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'pitas--pavo', 'Pavo', 'Pan árabe relleno de pechuga de pavo, variedad de quesos y salsa dijonnaise.', 31900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'pitas--doble-pocket', 'Doble Pocket', 'Pan árabe relleno de lomo ahumado de cerdo, salsa dijonnaise y variedad de quesos.', 25500, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'pitas--popeye-pocket', 'Popeye Pocket', 'Pan árabe relleno de espinaca, lomo ahumado de cerdo, cebolla, huevo, champiñones y tomate, gratinado con queso, acompañado con salsa amarilla y vinagreta verde.', 23900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'pitas--mozzarella-pocket', 'Mozzarella Pocket', 'Queso, salsa napolitana y albahaca.', 16200, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'pitas--champinon-pocket', 'Champiñón Pocket', 'Portobello y champiñones salteados con albahaca, tomates secos y rúgula, gratinados con queso.', 29200, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'pitas--capresa', 'Capresa', 'Pan árabe relleno de mozzarellina, tomates frescos y secos, rúgula y pesto.', 27900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'pitas--siciliana', 'Siciliana', 'Queso, salsa napolitana, tomates frescos, tomates secos, albahaca y aceite de oliva.', 27900, '[]'::jsonb, array[]::text[], 'reales/plato-pita-siciliana.png', 7),
  ((select id from c), 'pitas--vegetariana', 'Vegetariana', 'Queso, salsa napolitana, champiñones, cebolla, tomate, pimentón y apio.', 25900, '[]'::jsonb, array[]::text[], 'reales/plato-pita-vegetariana.png', 8),
  ((select id from c), 'pitas--griega', 'Griega', 'Queso, salsa napolitana, alcachofas, aceitunas moradas, cebolla, tomate y especias.', 27900, '[]'::jsonb, array[]::text[], null, 9);

with c as (insert into public.categorias (nombre, nota, orden) values ('PANNE COOK', 'Delicioso pan francés redondo, relleno con cualquiera de nuestras opciones:', 19) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'panne-cook--ternera', 'Ternera', 'Puedes pedirlo también con:', 35300, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'panne-cook--champinones', 'Champiñones', null, 35800, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'panne-cook--pollo-y-champinones', 'Pollo y Champiñones', 'Puedes pedirlo también con:', 34900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'panne-cook--queso', 'Queso', null, 35900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'panne-cook--pollo-al-curry', 'Pollo al Curry', null, 35900, '[]'::jsonb, array[]::text[], 'reales/plato-panne-cook-de-pollo-al-curry.png', 4),
  ((select id from c), 'panne-cook--stroganoff', 'Stroganoff', 'Julianas de lomo y champiñones en su salsa.', 44900, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'panne-cook--lomito-pimienta', 'Lomito Pimienta', 'Julianas de lomo y pimienta del Putumayo en su salsa.', 44900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'panne-cook--palmitos', 'Palmitos', 'Al Curry, al Ajillo o en Salsa de la Casa (Marco Polo).', 35900, '[]'::jsonb, array[]::text[], null, 7),
  ((select id from c), 'panne-cook--calamares', 'Calamares', 'Al Curry, al Ajillo o en Salsa de la Casa (Marco Polo).', 40700, '[]'::jsonb, array[]::text[], null, 8),
  ((select id from c), 'panne-cook--camarones', 'Camarones', 'Al Curry, al Ajillo o en Salsa de la Casa (Marco Polo). 1 Pídelo con ensalada verde, vinagre balsámico y aceite de oliva. Valor adicional: $6.400', 45900, '[]'::jsonb, array[]::text[], 'reales/plato-panne-cook-de-camarones.png', 9);

with c as (insert into public.categorias (nombre, nota, orden) values ('ENSALADAS', null, 20) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'ensaladas--cesar', 'Cesar', 'La clásica ensalada con crutones, tomates cherry y queso parmesano. Acompañada con pan centeno.', 29500, '[{"nombre": "Con Pollo", "precio": 29500}, {"nombre": "Con Salmón Ahumado", "precio": 41900}]'::jsonb, array[]::text[], 'reales/plato-ensalada-cesar-con-salmon.png', 0),
  ((select id from c), 'ensaladas--florentina', 'Florentina', 'Mozzarellina, variedad de lechugas frescas, albahaca fresca, tomates secos, frescos y cherry, champiñones, pesto, aguacate, aceitunas negras y vinagre balsámico.', 35500, '[]'::jsonb, array[]::text[], 'reales/plato-ensalada-florentina.png', 1),
  ((select id from c), 'ensaladas--thai', 'Thai', 'Pechuga de pavo con ajonjolí y albahaca, variedad de lechugas frescas, rúgula, apio, champiñones, pimentón, tomate cherry, cebollas crocantes y una vinagreta oriental.', 36200, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'ensaladas--mediterranea', 'Mediterránea', 'Camarones, calamares, pesto, variedad de lechugas frescas, apio, champiñones, cebolla roja, aceitunas negras, vinagreta balsámica y cebollas crocantes.', 42900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'ensaladas--marroqui', 'Marroquí', 'Couscous preparado con especias, aguacate, chutney de mango, quinua tostada y ensalada verde con vinagreta marroquí.', 29200, '[{"nombre": "Con Camarón", "precio": 42900}, {"nombre": "Con Pollo", "precio": 29200}]'::jsonb, array[]::text[], 'reales/plato-ensalada-marroqui-con-camarones.png', 4),
  ((select id from c), 'ensaladas--tuna-salad', 'Tuna Salad', 'Atún ventresca, variedad de lechugas frescas, rúgula, pepino, albahaca, champiñones, apio, aguacate, tomate cherry, aceitunas negras y vinagreta de finas hierbas. Acompañado con pan árabe.', 40900, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'ensaladas--valparaiso', 'Valparaíso', 'Filete de salmón ahumado con merkén, acompañado de quinua negra, kale con queso parmesano y Grana Padano, picadillo de tomate, aguacate y vinagreta árabe.', 42900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'ensaladas--torina', 'Torina', 'Mozzarellina envuelta en jamón serrano con cebollas caramelizadas y pimienta, variedad de lechugas, rúgula, tomate cherry y vinagreta a base de mostaza Dijón.', 38500, '[]'::jsonb, array[]::text[], 'reales/plato-ensalada-torina.png', 7);

with c as (insert into public.categorias (nombre, nota, orden) values ('JUGOS', null, 21) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'jugos--mora-2', 'Mora', null, 7900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'jugos--mango-2', 'Mango', null, 8200, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'jugos--mandarina-2', 'Mandarina', null, 10200, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'jugos--fresa-2', 'Fresa', null, 8300, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'jugos--guanabana-2', 'Guanábana', 'Jugo natural en leche.', 8500, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'jugos--feijoa', 'Feijoa', null, 7900, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'jugos--durazno', 'Durazno', null, 8900, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'jugos--frambuesa-2', 'Frambuesa', null, 10500, '[]'::jsonb, array[]::text[], null, 7);

with c as (insert into public.categorias (nombre, nota, orden) values ('LIMONADAS', null, 22) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'limonadas--natural-2', 'Natural', null, 6900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'limonadas--limon-mandarino', 'Limón Mandarino', null, 7900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'limonadas--hierbabuena-2', 'Hierbabuena', null, 8300, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'limonadas--mango-biche-2', 'Mango Biche', null, 9600, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'limonadas--coco-2', 'Coco', null, 11600, '[]'::jsonb, array[]::text[], null, 4);

with c as (insert into public.categorias (nombre, nota, orden) values ('BATIDOS', null, 23) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'batidos--pina-jengibre-y-hierbabuena-2', 'Piña, Jengibre y Hierbabuena', null, 9900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'batidos--alegria-2', 'Alegría', 'Mezcla de frutas del campo: mango, maracuyá y piña.', 11200, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'batidos--bienestar-2', 'Bienestar', 'Mezcla de frutas del campo: manzana, pera, feijoa y hierbabuena.', 11200, '[]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('OTRAS BEBIDAS', null, 24) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'otras-bebidas--agua-manantial-2', 'Agua Manantial®', null, 7500, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'otras-bebidas--agua-manantial-con-gas-2', 'Agua Manantial® con Gas', null, 7200, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'otras-bebidas--gaseosas', 'Gaseosas', 'Coca-Cola® original, Coca-Cola® zero, Sprite® o Kola Roman®.', 6500, '[]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('CERVEZAS', null, 25) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'cervezas--club-colombia', 'Club Colombia', null, 10900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'cervezas--stella-artois', 'Stella Artois', null, 13300, '[]'::jsonb, array[]::text[], null, 1);

with c as (insert into public.categorias (nombre, nota, orden) values ('VINOS', null, 26) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'vinos--vino-amoretinto-tinto', 'Vino AMORETINTO - Tinto', 'Cepa: Merlot | Origen: Chile', 68500, '[{"nombre": "Media Botella", "precio": 68500}, {"nombre": "Botella", "precio": 109500}]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'vinos--vino-amoretinto-blanco', 'Vino AMORETINTO -  Blanco', 'Cepa: Gewurstraminier | Origen: Chile', 68500, '[{"nombre": "Media Botella", "precio": 68500}, {"nombre": "Botella", "precio": 109500}]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'vinos--vino-prosecco', 'Vino Prosecco', 'Cepa: Glera | Origen: Italia', 83000, '[{"nombre": "Media Botella", "precio": 83000}, {"nombre": "Botella", "precio": 118500}]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES DULCES', null, 27) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-dulces--nutella', 'Nutella®', 'Crepe de Nutella® con crema chantilly. Pídelo también con:', 16900, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 0),
  ((select id from c), 'crepes-dulces--nutella-fresas', 'Fresas', 'Variante del crepe de Nutella®.', 17600, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-dulces--nutella-banano', 'Banano', 'Variante del crepe de Nutella®.', 17600, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-dulces--chocolate-fondue', 'Chocolate Fondue', 'Crepe con fresas y banano, helado de Vainilla, crema chantilly y chocolate.', 14800, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes-dulces--baby-doll', 'Baby Doll', 'Banano fresco, helado de Vainilla, nueces, chocolate caliente y crema chantilly.', 15600, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 4),
  ((select id from c), 'crepes-dulces--mont-blanc', 'Mont Blanc', 'Crepe con chocolate blanco, fresas y crema chantilly.', 17800, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'crepes-dulces--cleopatra', 'Cleopatra', 'Crepe con tajadas de banano y fresa, helado de Mora, crema chantilly y salsa de uva e inglesa.', 14600, '[]'::jsonb, array[]::text[], null, 6);

with c as (insert into public.categorias (nombre, nota, orden) values ('WAFFLES DE DULCE', null, 28) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'waffles-de-dulce--mantequilla-y-syrup-o-miel', 'Mantequilla y Syrup o Miel', null, 11200, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'waffles-de-dulce--sencillo-con-crema-chantilly', 'Sencillo con Crema Chantilly', 'Pídelo con una de nuestras salsas de dulce: arequipe, chocolate, melocotón, inglesa, piña, caramelo, agrás o crema de limón.', 14200, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'waffles-de-dulce--sencillo-con-helado', 'Sencillo con Helado', 'Pídelo con una de nuestras salsas de dulce: arequipe, chocolate, melocotón, inglesa, piña, caramelo, agrás o crema de limón.', 15600, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'waffles-de-dulce--especial', 'Especial', 'Con helado y crema chantilly. Escoge tres o cuatro salsas diferentes: arequipe, chocolate, melocotón, inglesa, piña, frutos del bosque, caramelo, jagrás o crema de limón.', 17900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'waffles-de-dulce--arequipe', 'Arequipe', 'Con salsa de arequipe, helado de Vainilla y Arequipe con crema chantilly.', 14600, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'waffles-de-dulce--arequipe-y-banano', 'Arequipe y Banano', 'Tajadas de banano fresco con salsa de arequipe, helado de Vainilla y Arequipe con crema chantilly.', 14900, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'waffles-de-dulce--nutella', 'Nutella®', 'Con helado de Vainilla y crema chantilly.', 17600, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 6),
  ((select id from c), 'waffles-de-dulce--nutella-y-banano', 'Nutella® y Banano', 'Tajadas de banano fresco, helado Old Style y crema chantilly.', 17900, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 7),
  ((select id from c), 'waffles-de-dulce--frutos-del-bosque', 'Frutos del Bosque', 'Con helado de Vainilla y crema chantilly.', 15600, '[]'::jsonb, array[]::text[], null, 8);

with c as (insert into public.categorias (nombre, nota, orden) values ('MINI WAFFLES DE DULCE', null, 29) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'mini-waffles-de-dulce--mantequilla-y-syrup-o-miel', 'Mantequilla y Syrup o Miel', null, 11200, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'mini-waffles-de-dulce--arequipe', 'Arequipe', 'Con helado de Vainilla y crema chantilly.', 14600, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'mini-waffles-de-dulce--chocolate', 'Chocolate', 'Con helado de Vainilla y crema chantilly.', 14600, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'mini-waffles-de-dulce--nutella', 'Nutella®', 'Con helado de Vainilla y crema chantilly.', 17600, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 3),
  ((select id from c), 'mini-waffles-de-dulce--frutos-del-bosque', 'Frutos del Bosque', 'Frutos del bosque con helado de Vainilla y crema chantilly.', 15600, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 4);

with c as (insert into public.categorias (nombre, nota, orden) values ('WAFFLES DE SAL', null, 30) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'waffles-de-sal--waffle-d-choclo', 'Waffle D''Choclo', 'Waffle de maíz relleno de queso, con queso 7 cueros y suero costeño.', 16500, '[]'::jsonb, array['VEGETARIANO']::text[], null, 0),
  ((select id from c), 'waffles-de-sal--mini-waffle-d-yuca', 'Mini Waffle D''Yuca', 'Un mini waffle con mantequilla, panela orgánica molida y jalea de guayaba.', 8900, '[]'::jsonb, array['VEGETARIANO']::text[], null, 1),
  ((select id from c), 'waffles-de-sal--pidelo-con-doble-mini-waffles', 'Pídelo con doble Mini Waffles', null, 15900, '[]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('GOFRES', null, 31) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'gofres--nutella', 'Nutella®', null, 17900, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 0),
  ((select id from c), 'gofres--especial', 'Especial', 'Con helado y crema chantilly. Escoge dos salsas diferentes: arequipe, chocolate, Nutella®, frutos del bosque.', 18700, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'gofres--chocolate', 'Chocolate', null, 14100, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'gofres--arequipe', 'Arequipe', null, 14600, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'gofres--chocolate-blanco', 'Chocolate Blanco', null, 14400, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'gofres--caramelo', 'Caramelo', null, 8400, '[]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'gofres--frutos-del-bosque', 'Frutos del Bosque', null, 14500, '[]'::jsonb, array[]::text[], null, 6),
  ((select id from c), 'gofres--mantequilla-y-syrup', 'Mantequilla y Syrup', null, 9900, '[]'::jsonb, array[]::text[], null, 7);

with c as (insert into public.categorias (nombre, nota, orden) values ('COPAS GOURMET', null, 32) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'copas-gourmet--copa-limena', 'Copa Limeña', 'Helado de Vainilla con salsa de arequipe, frutos del bosque, merengue, copos de guanábana y crema chantilly.', 16800, '[]'::jsonb, array[]::text[], null, 0);

with c as (insert into public.categorias (nombre, nota, orden) values ('GLASÉS DECO', null, 33) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'glases-deco--banana-split', 'Banana Split', 'Clásica combinación de helado de Vainilla, Fresa y Chocolate. Acompañado de crema chantilly, nueces, banano, salsa de chocolate y arequipe.', 17500, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 0);

with c as (insert into public.categorias (nombre, nota, orden) values ('AMANTES DEL CHOCOLATE', null, 34) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'amantes-del-chocolate--tarta-de-chocolate-y-fudge', 'Tarta de Chocolate y Fudge', 'Fusión de helado de Chocolate y Coffee Toffee con fudge de chocolate, en una base de almendras tostadas y crocante italiano.', 15500, '[]'::jsonb, array['CONTIENE NUECES / MANÍ']::text[], null, 0),
  ((select id from c), 'amantes-del-chocolate--vainilla-hot-chocolate', 'Vainilla Hot Chocolate', 'Helado Old Style, almendras tostadas entre crema chantilly y chocolate caliente con el que le darás gusto a tu gusto.', 14900, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 1);

with c as (insert into public.categorias (nombre, nota, orden) values ('ITALIANOS', null, 35) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'italianos--tiramisu', 'Tiramisú', 'Composición italiana de helado de Old Style, bizcochuelo bañado con cogñac, entonado con salsas inglesa, chocolate y de café.', 14900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'italianos--vesubio', 'Vesubio', 'Clásica combinación italiana de helado de Fresa, Vainilla y Limón, bañado con salsa de uva y crema chantilly.', 11900, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'italianos--capri', 'Capri', 'Dulce sensación de helado de Vainilla sobre una crujiente galleta mantequilla, con salsas de arequipe, uva y crema chantilly.', 12200, '[]'::jsonb, array[]::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('DELIZZIA', null, 36) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'delizzia--capricho-de-maracuya', 'Capricho de Maracuyá', 'Helado de Yogurt de Maracuyá con coulis de maracuyá, fresas, melocotones, galleta de mantequilla y el crujiente de la galleta de encaje.', 15800, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'delizzia--tentacion', 'Tentación', 'Bizcochuelo bañado con un toque de licor que exalta el sabor del helado de Vainilla, Coffee Toffee y Chocolate. Combina sutilmente con salsa de chocolate, nueces y crema chantilly.', 16900, '[]'::jsonb, array['CONTIENE NUECES / MANÍ']::text[], null, 1),
  ((select id from c), 'delizzia--festival', 'Festival', 'Bizcochuelo acompañado de helados de Mora, Fresa, Maracuyá, Limón y Vainilla, con trocitos de banano, fresas frescas, salsa de uva y crema chantilly.', 22900, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'delizzia--filosofia-acaramelada', 'Filosofía Acaramelada', 'Donde el helado de Vainilla en crocante de macadamias y almendras, las tajadas de banano y la salsa de caramelo, se unen para darle sentido y sabor a la vida.', 11900, '[]'::jsonb, array['CONTIENE NUECES / MANÍ']::text[], null, 3),
  ((select id from c), 'delizzia--merengue-glaze', 'Merengue Glazé', 'Merengue y helado de Vainilla, juegan con la salsa de chocolate caliente, nueces y crema chantilly para proporcionar solo placer.', 16500, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 4),
  ((select id from c), 'delizzia--copa-melocoton', 'Copa Melocotón', 'Helado de Vainilla y Yogurt de Maracuyá con melocotones tajados, coulis de maracuyá, crema chantilly y crujiente galleta de encaje.', 15600, '[]'::jsonb, array[]::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('COPAS Y COPAS', null, 37) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'copas-y-copas--banana-royal', 'Banana Royal', 'Alucinante mezcla de helado de Vainilla y Chocolate con tajadas de fresa, banano, salsa de chocolate caliente, crujiente galleta de encaje y crema chantilly.', 14900, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'copas-y-copas--suprema', 'Suprema', 'Helado de Vainilla y tajaditas de banano entre crema chantilly, bañadas con salsa de chocolate y arequipe, mini cono de galleta y nueces.', 15800, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 1),
  ((select id from c), 'copas-y-copas--dama-blanca', 'Dama Blanca', 'Helado de Vainilla y Chocolate acompañado con salsa de chocolate, nueces y crema chantilly.', 11900, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 2),
  ((select id from c), 'copas-y-copas--alaska', 'Alaska', 'Profiterol con salsa inglesa, helado de Vainilla y Mora, con salsa de uva y crema chantilly.', 15900, '[]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'copas-y-copas--brownie', 'Brownie', 'Helado de Vainilla mezclado con trozos de brownie, salsa de caramelo y chocolate.', 12900, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'copas-y-copas--dulce-encanto', 'Dulce Encanto', 'Bizcochuelo bañado en salsa inglesa y arequipe, con helado Cocado, tartufino de chocolate y crujiente galleta de encaje.', 15800, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('HELADOS DE TEMPORADA', 'Sabores que vuelven para hacerte sonreír. Disponibles únicamente en tamaño de 470 ml.', 38) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'helados-de-temporada--dulce-de-leche-470ml', 'Dulce de Leche 470ml', 'Helado de Dulce de Leche argentino con stracciatella.', 39000, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'helados-de-temporada--maracuya-stracciatella-470ml', 'Maracuyá Stracciatella 470ml', 'Nuestro helado Pasión Tropical. Helado de Maracuyá en agua con trozos de chocolate oscuro y vetas de maracuyá.', 28500, '[]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'helados-de-temporada--yogurt-de-guayaba-470ml', 'Yogurt de Guayaba 470ml', 'Helado de Yogurt con vetas de guayaba.', 22000, '[]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'helados-de-temporada--vainilla-chocoalmond-470ml', 'Vainilla Chocoalmond 470ml', 'Helado de Vainilla con almendras tostadas y fudge de chocolate.', 24000, '[]'::jsonb, array['CONTIENE NUECES']::text[], null, 3),
  ((select id from c), 'helados-de-temporada--lulada-470ml', 'Lulada 470ml', 'Helado de Lulo en agua.', 20500, '[]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'helados-de-temporada--yogurt-griego-con-amarenas', 'Yogurt Griego con Amarenas', 'Helado de Yogurt Griego con cerezas amarenas italianas.', 26000, '[]'::jsonb, array[]::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('INFANTILES', null, 39) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'infantiles--helado-piggy', 'Helado Piggy', 'Con helado de Chicle.', 9800, '[]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'infantiles--samy', 'Samy', 'Pingüino con helado de Vainilla.', 9800, '[]'::jsonb, array[]::text[], null, 1);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — VINAGRETAS', 'Presentación de 250 ml.', 41) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-vinagretas--vinagreta-balsamico', 'Vinagreta Balsámico', 'Perfecta mezcla de vinagre balsámico, aceite de oliva y miel.', 23300, '[]'::jsonb, array['VEGETARIANO']::text[], null, 0),
  ((select id from c), 'crepes-en-casa-vinagretas--vinagreta-oriental', 'Vinagreta Oriental', 'Mezcla de vinagres, mostaza y un toque agridulce.', 23300, '[]'::jsonb, array['VEGETARIANO']::text[], null, 1),
  ((select id from c), 'crepes-en-casa-vinagretas--vinagreta-mostaza', 'Vinagreta Mostaza', 'Vinagreta donde la mostaza es protagonista. ¡Úsala para acompañar lo que más te guste!', 23300, '[]'::jsonb, array['VEGETARIANO']::text[], null, 2);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — SOPAS', null, 42) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-sopas--covarachia', 'Covarachía', null, 14900, '[{"nombre": "500ml", "precio": 14900}, {"nombre": "1lt", "precio": 20500}]'::jsonb, array['VEGETARIANO', 'VEGANO', 'LIGERAMENTE PICANTE']::text[], null, 0),
  ((select id from c), 'crepes-en-casa-sopas--cebolla', 'Cebolla', null, 16200, '[{"nombre": "500ml", "precio": 16200}, {"nombre": "1lt", "precio": 25000}]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-en-casa-sopas--espinaca', 'Espinaca', null, 14900, '[{"nombre": "500ml", "precio": 14900}, {"nombre": "1lt", "precio": 20500}]'::jsonb, array['VEGETARIANO']::text[], null, 2),
  ((select id from c), 'crepes-en-casa-sopas--lentejas', 'Lentejas', null, 19300, '[{"nombre": "500ml", "precio": 19300}, {"nombre": "1lt", "precio": 32800}]'::jsonb, array['VEGETARIANO', 'VEGANO']::text[], null, 3),
  ((select id from c), 'crepes-en-casa-sopas--vida-en-verdes', 'Vida en Verdes', null, 18000, '[{"nombre": "500ml", "precio": 18000}, {"nombre": "1lt", "precio": 30000}]'::jsonb, array['VEGETARIANO']::text[], null, 4),
  ((select id from c), 'crepes-en-casa-sopas--soy-otono', 'Soy Otoño', null, 15900, '[{"nombre": "500ml", "precio": 15900}, {"nombre": "1lt", "precio": 26200}]'::jsonb, array['VEGANO']::text[], null, 5);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — SALSAS', null, 43) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-salsas--hogao', 'Hogao', null, 10900, '[{"nombre": "250ml", "precio": 10900}, {"nombre": "500ml", "precio": 16900}]'::jsonb, array['VEGANO']::text[], null, 0),
  ((select id from c), 'crepes-en-casa-salsas--pesto', 'Pesto', null, 24000, '[{"nombre": "250ml", "precio": 24000}]'::jsonb, array['VEGETARIANO', 'CONTIENE NUECES / MANÍ']::text[], null, 1),
  ((select id from c), 'crepes-en-casa-salsas--curry', 'Curry', null, 24900, '[{"nombre": "500ml", "precio": 24900}, {"nombre": "1lt", "precio": 40000}]'::jsonb, array['VEGETARIANO']::text[], null, 2),
  ((select id from c), 'crepes-en-casa-salsas--napolitana', 'Napolitana', null, 17900, '[{"nombre": "500ml", "precio": 17900}, {"nombre": "1lt", "precio": 30000}]'::jsonb, array['VEGETARIANO', 'VEGANO']::text[], null, 3),
  ((select id from c), 'crepes-en-casa-salsas--salsa-de-la-casa', 'Salsa de la Casa', null, 30800, '[{"nombre": "500ml", "precio": 30800}, {"nombre": "1lt", "precio": 48000}]'::jsonb, array['VEGETARIANO']::text[], null, 4),
  ((select id from c), 'crepes-en-casa-salsas--salsa-champinones', 'Salsa Champiñones', null, 25000, '[{"nombre": "500ml", "precio": 25000}, {"nombre": "1lt", "precio": 40000}]'::jsonb, array['VEGETARIANO']::text[], null, 5),
  ((select id from c), 'crepes-en-casa-salsas--mexicana', 'Mexicana', null, 17900, '[{"nombre": "500ml", "precio": 17900}, {"nombre": "1lt", "precio": 30000}]'::jsonb, array['VEGETARIANO']::text[], null, 6),
  ((select id from c), 'crepes-en-casa-salsas--parmesana', 'Parmesana', null, 30800, '[{"nombre": "500ml", "precio": 30800}, {"nombre": "1lt", "precio": 52500}]'::jsonb, array['VEGETARIANO']::text[], null, 7);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — SALSAS CON PROTEÍNA', null, 44) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--stroganoff', 'Stroganoff', null, 49900, '[{"nombre": "500ml", "precio": 49900}]'::jsonb, array[]::text[], null, 0),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--lomito-pimienta', 'Lomito Pimienta', null, 56000, '[{"nombre": "500ml", "precio": 56000}]'::jsonb, array[]::text[], null, 1),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--pollo', 'Pollo', null, 38500, '[{"nombre": "500ml", "precio": 38500}]'::jsonb, array[]::text[], null, 2),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--pollo-thai', 'Pollo Thai', null, 38900, '[{"nombre": "500ml", "precio": 38900}]'::jsonb, array[]::text[], null, 3),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--cochinita-pibil', 'Cochinita Pibil', null, 37900, '[{"nombre": "500ml", "precio": 37900}]'::jsonb, array[]::text[], null, 4),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--carne-desmechada', 'Carne Desmechada', null, 40000, '[{"nombre": "500ml", "precio": 40000}]'::jsonb, array[]::text[], null, 5),
  ((select id from c), 'crepes-en-casa-salsas-con-proteina--bolonesa', 'Boloñesa', null, 25700, '[{"nombre": "500ml", "precio": 25700}, {"nombre": "1lt", "precio": 40000}]'::jsonb, array[]::text[], null, 6);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — SABORES DULCES', null, 45) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-sabores-dulces--arequipe', 'Arequipe', null, 11800, '[{"nombre": "250ml", "precio": 11800}, {"nombre": "500ml", "precio": 20000}]'::jsonb, array['VEGETARIANO']::text[], null, 0),
  ((select id from c), 'crepes-en-casa-sabores-dulces--salsa-frutos-del-bosque', 'Salsa Frutos del Bosque', null, 15800, '[{"nombre": "250ml", "precio": 15800}, {"nombre": "500ml", "precio": 24700}]'::jsonb, array['VEGETARIANO', 'VEGANO']::text[], null, 1),
  ((select id from c), 'crepes-en-casa-sabores-dulces--coulis-de-maracuya', 'Coulis de Maracuyá', null, 18000, '[{"nombre": "250ml", "precio": 18000}, {"nombre": "500ml", "precio": 24000}]'::jsonb, array['VEGETARIANO', 'VEGANO']::text[], null, 2),
  ((select id from c), 'crepes-en-casa-sabores-dulces--jalea-de-guayaba', 'Jalea de Guayaba', null, 15900, '[{"nombre": "250ml", "precio": 15900}, {"nombre": "500ml", "precio": 25900}]'::jsonb, array['VEGETARIANO', 'VEGANO']::text[], null, 3);

with c as (insert into public.categorias (nombre, nota, orden) values ('CREPES EN CASA — MASAS', '¡Disfruta nuestra masas listas para preparar pancakes o waffles en casa! Presentación de 500 ml.', 46) returning id)
insert into public.productos (categoria_id, slug, nombre, descripcion, precio, variantes, etiquetas, foto_url, orden) values
  ((select id from c), 'crepes-en-casa-masas--masa-waffle', 'Masa Waffle', null, 13400, '[]'::jsonb, array['VEGETARIANO']::text[], null, 0),
  ((select id from c), 'crepes-en-casa-masas--masa-de-yuca', 'Masa de Yuca', null, 26800, '[]'::jsonb, array['VEGETARIANO']::text[], null, 1),
  ((select id from c), 'crepes-en-casa-masas--masa-de-choclo', 'Masa de Choclo', null, 24800, '[]'::jsonb, array['VEGETARIANO']::text[], null, 2);

commit;
