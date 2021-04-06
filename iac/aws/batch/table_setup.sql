-- DROP DATABASE ailab_tracker;
CREATE DATABASE IF NOT EXISTS <ENTER DATABASE HERE>;
USE <ENTER DATABASE HERE>;

DROP TABLE IF EXISTS schema_info;
CREATE TABLE schema_info (
   version VARCHAR(20),
   created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   notes TEXT
) ENGINE=InnoDB;
insert into schema_info set version='0.0.1', notes='initial dev version';

DROP TABLE IF EXISTS job_type;
CREATE TABLE job_type (
   id BIGINT NOT NULL AUTO_INCREMENT,
   name VARCHAR(100) NOT NULL,
   args TEXT,
   notes TEXT,
   status int NOT NULL DEFAULT 0,
   PRIMARY KEY ( id ),
   INDEX name_index (name)
) ENGINE=InnoDB;
insert into job_type set id=1, name='unknown', status=1;
insert into job_type set id=2, name='experiment', status=1;
insert into job_type set id=3, name='job', status=1;
insert into job_type set id=4, name='jobset', status=1;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS job;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE job (
   id BIGINT NOT NULL AUTO_INCREMENT,
   type_id BIGINT NOT NULL DEFAULT 1,
   name VARCHAR(100) NOT NULL,
   job_uuid VARCHAR(100) NOT NULL,
   created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   parent_id BIGINT,
   args JSON,
   notes TEXT,
   status int NOT NULL DEFAULT 0,
   PRIMARY KEY ( id ),
   INDEX parent_id_index (parent_id),
   FOREIGN KEY (parent_id)
        REFERENCES job(id)
        ON DELETE CASCADE,
   FOREIGN KEY (type_id)
        REFERENCES job_type(id),
   UNIQUE ( job_uuid )
) ENGINE=InnoDB;

DROP TABLE IF EXISTS job_attribute;
CREATE TABLE job_attribute (
   job_id BIGINT NOT NULL,
   k VARCHAR(100) NOT NULL,
   v VARCHAR(200),
   longval TEXT,
   INDEX k_index (k),
   INDEX v_index (v),
   FOREIGN KEY ( job_id )
   	   REFERENCES job(id)
	   ON DELETE CASCADE
) ENGINE=InnoDB;

-- where it is being run, uuid being used to reference the job, laptop username, ip address, container id [todo: git url, git commit]


DROP TABLE IF EXISTS job_event_type;
CREATE TABLE job_event_type (
   id BIGINT NOT NULL AUTO_INCREMENT,
   name VARCHAR(100) NOT NULL,
   args TEXT,
   notes TEXT,
   PRIMARY KEY ( id ),
   INDEX name_index (name)
) ENGINE=InnoDB;
insert into job_event_type set id=1, name='unknown';
insert into job_event_type set id=2, name='state';
insert into job_event_type set id=3, name='request';
insert into job_event_type set id=4, name='log';
insert into job_event_type set id=5, name='callback';
insert into job_event_type set id=6, name='execution';
insert into job_event_type set id=7, name='uuidchange';

-- insert into job_event_type set id=2, name='';
-- insert into job_event_type set id=, name='';

-- insert into job_event_type set id=1, name='cli';
-- insert into job_event_type set id=2, name='aws-batch';
-- insert into job_event_type set id=3, name='lambda';
-- insert into job_event_type set id=4, name='runner';

-- insert into job_event_type set id=4, name='';
-- insert into job_event_type set id=5, name='';
-- insert into job_event_type set id=6, name='';
-- insert into job_event_type set id=7, name='';
-- insert into job_event_type set id=8, name='';
-- insert into job_event_type set id=9, name='';
-- insert into job_event_type set id=, name='';
-- insert into job_event_type set id=, name='';

DROP TABLE IF EXISTS job_event;
CREATE TABLE job_event (
   id BIGINT NOT NULL AUTO_INCREMENT,
   type_id BIGINT NOT NULL DEFAULT 1,
   job_id BIGINT NOT NULL,
   src VARCHAR(50) NOT NULL,
   created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   args text,
   raw JSON,
   status int NOT NULL DEFAULT 0,
   PRIMARY KEY ( id ),
   FOREIGN KEY (job_id)
        REFERENCES job(id)
        ON DELETE CASCADE,
   FOREIGN KEY (type_id)
        REFERENCES job_event_type(id)
) ENGINE=InnoDB;

-- state transitions; start in, run in, job dies, cascade on delete