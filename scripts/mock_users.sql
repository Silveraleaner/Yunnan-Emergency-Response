CREATE TABLE IF NOT EXISTS sys_user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    real_name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (1, 'ming57', '尹建军', '$2b$12$NfWkRkjTEmvF/wD7RWFbSOE/tjKk7nkg0t4o3HO3OGDArHJx6MC5q', 'admin', '18537806388', NULL, '2025-12-03 22:29:40');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (2, 'qiuli', '刘琴', '$2b$12$AEEpUI/MBDRUmAo.LxYt1ekcoMCes4hbmjll38QF9MgShB0AfiIXa', 'admin', '18325715382', NULL, '2026-04-19 09:47:47');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (3, 'gang86', '傅想', '$2b$12$jU0AwDd8hBT9ql0BdZnwve4ot1clbNkJs61IXoJtMi.SCF1k1H./W', 'commander', '13569176970', 'imo@example.org', '2025-10-21 05:52:19');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (4, 'xuejun', '陈琴', '$2b$12$6A8EgCC5syhsqLYXsnsPIuuZdw6JzqSTcmPXmb6YLoDV2o4JxcduS', 'commander', '18287697574', 'jie55@example.com', '2025-08-27 02:14:31');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (5, 'kangqiang', '梁雷', '$2b$12$Yb2f7vDD.93pWSMnOhG2QOu2SFzx3IurwMMpduX21MVw9oAQhhh.a', 'commander', '13146947965', NULL, '2026-07-20 02:16:08');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (6, 'junguo', '阎桂英', '$2b$12$VH1MdF47eBdKQjMZuLhRc.jVPVZ61s0LeATfKiu9hZRelMDS6s98u', 'commander', '17066552396', NULL, '2025-09-15 02:09:43');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (7, 'taowei', '马洁', '$2b$12$jnODwwwAbZdUIdXoumSXwu/xy6LM2s6xxfRAIKaq2dvG35GkgNl4q', 'commander', '17074233801', 'li44@example.net', '2026-01-22 12:46:29');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (8, 'chao41', '陈峰', '$2b$12$ACiN6vKDG3tDJQMpPRSjRuPSyvKZ6fvxiBFmAKRe1QEQ5T.tdCMc.', 'reporter', '13394024176', 'mingtang@example.net', '2026-04-10 21:58:11');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (9, 'eqin', '施洁', '$2b$12$C8/Dx2ouao1g/ls45WkFu.CX3f/I0JjeBfmELyeEgQR/LV7z1AoAq', 'reporter', '18665964672', 'leixiuying@example.net', '2025-08-05 02:42:58');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (10, 'hmeng', '彭秀兰', '$2b$12$5pDeiMCU/WNWZRKxXmw21u9qdjhnqDeACMkADUVmZ5JztlJ3DPsWS', 'reporter', '15834576917', NULL, '2026-06-01 09:06:26');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (11, 'chaoding', '应帅', '$2b$12$kWP5mnrffPkZ18GphtCkROqV65GIWnf7bSdQ0rJrpVxawldQnnI3O', 'reporter', '15729416447', 'zouyan@example.org', '2026-04-13 19:31:37');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (12, 'lei21', '徐琴', '$2b$12$iqtcUYGwJQNb/.NZgorcNexGN2NermPQ2lHG/7Qp/etjXP5j98lQS', 'reporter', '15222379406', NULL, '2025-08-10 02:54:17');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (13, 'jing74', '余佳', '$2b$12$SqmN/tA06g5M/w5fl21AtOrxpLzRpZ0rx.amJ2YfcTOQVe7QJWBeu', 'reporter', '18192011276', 'liren@example.org', '2025-12-28 11:23:19');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (14, 'jiexiong', '温旭', '$2b$12$aXm0eFKQwQCkL8ruA8BBnO5Y/5AK5wNYapgxjOzopDRxAGPhFo1Te', 'reporter', '15016715658', 'weikang@example.com', '2026-04-03 14:05:27');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (15, 'leiwei', '徐红梅', '$2b$12$ZmBAGDafATK76pDCSVRv3ew4vRhwk7RmEeLC1DQP5AtJywSOt8F7e', 'reporter', '13007754401', NULL, '2026-02-02 17:30:38');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (16, 'yang91', '贺建平', '$2b$12$EM4Szz3ZKMR3IEsVpMDzguOmiUYazV/3VuB9X48xePaSj.WYgjEdO', 'reporter', '18160990910', 'xiulan78@example.org', '2025-09-30 14:47:24');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (17, 'tianguiying', '李霞', '$2b$12$aVpKxoyOO.32onS5BjAThulh75KQZ70VZ7DDu7E6ABI0I4byjywBy', 'reporter', '18240228035', 'daixia@example.com', '2025-12-09 05:27:41');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (18, 'wangqiang', '林霞', '$2b$12$vzwgBrvZ8RU0ccUr8hy8VO9ScVzIfk.7YgTJWzB6w1V.s7dSHy0FW', 'reporter', '18332516980', 'yanxiao@example.net', '2025-10-05 14:31:40');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (19, 'yongkong', '陈莉', '$2b$12$GXcg7zB7rB7KvbPRo0hlyuOiYFVP9PR9Z3Oo63yvMUuSuAvdoquUG', 'reporter', '13843672663', 'xiachao@example.net', '2026-03-14 21:38:13');
INSERT INTO users (user_id, username, real_name, password, role, phone, email, created_at) VALUES (20, 'wei56', '张彬', '$2b$12$TjHTJxk6PZPBQaf/.qFYoOZJY6gzbH3D56MB1a2P.acLcWFko2KDy', 'reporter', '15118403912', 'qiang56@example.net', '2025-09-30 07:07:11');
