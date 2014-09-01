--    uniCenta oPOS - Touch Friendly Point Of Sale
--    Copyright (C) 2009-2014 uniCenta
--    http://www.unicenta.net
--
--    This file is part of uniCenta oPOS.
--
--    uniCenta oPOS is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    uniCenta oPOS is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with uniCenta oPOS.  If not, see <http://www.gnu.org/licenses/>.

-- Database upgrade script for Oracle
-- v3.02 - v3.50

CREATE TABLE csvimport (
  ID VARCHAR2(256) NOT NULL,
  ROWNUMBER VARCHAR2(256),
  CSVERROR VARCHAR2(256),
  REFERENCE VARCHAR2(256),
  CODE VARCHAR2(256),
  NAME VARCHAR2(256),
  PRICEBUY DOUBLE PRECISION,
  PRICESELL DOUBLE PRECISION,
  PREVIOUSBUY DOUBLE PRECISION,
  PREVIOUSSELL DOUBLE PRECISION,
  PRIMARY KEY (ID)
);

CREATE TABLE DRAWEROPENED (
    OPENDATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    NAME VARCHAR(255),
    TICKETID VARCHAR(255)
);

CREATE TABLE MOORERS (
  VESSELNAME VARCHAR2(256),
  SIZE INTEGER,
  DAYS INTEGER,
  POWER BIT DEFAULT b'0' NOT NULL
  );

CREATE TABLE PICKUP_NUMBER (
ID INTEGER NOT NULL
);
INSERT INTO PICKUP_NUMBER VALUES(1);

CREATE TABLE TICKETSNUM_PAYMENT (
 ID INTEGER NOT NULL
);

--
-- UPDATE existing tables
--
UPDATE ROLES SET PERMISSIONS = $FILE{/com/openbravo/pos/templates/Role.Administrator.xml} WHERE ID = '0';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Menu.Root.txt} WHERE ID = '0';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.CloseCash.xml} WHERE ID = '25';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid.XML} WHERE ID = '26';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid2.xml} WHERE ID = '27';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.PartialCash.xml} WHERE ID = '31';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.Ticket.xml} WHERE ID = '33';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.Ticket2.xml} WHERE ID = '34';
UPDATE RESOURCES SET CONTENT = $FILE{/com/openbravo/pos/templates/Printer.TicketPreview.xml} WHERE ID = '37';

-- ADD NEW RESOURCES
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('56', 'Printer.Product', 0, $FILE{/com/openbravo/pos/templates/Printer.Product.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('57', 'Printer.TicketClose', 0, $FILE{/com/openbravo/pos/templates/Printer.TicketClose.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('58', 'Printer.TicketNew', 0, $FILE{/com/openbravo/pos/templates/Printer.TicketLine.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('59', 'script.AddLineNote', 0, $FILE{/com/openbravo/pos/templates/script.AddLineNote.txt});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('60', 'script.ServiceCharge', 0, $FILE{/com/openbravo/pos/templates/script.script.ServiceCharge.txt});


--
-- ALTER existing tables
--
ALTER TABLE CATEGORIES ADD COLUMN TEXTTIP VARCHAR2(256) NOT NULL;
ALTER TABLE CATEGORIES ADD COLUMN CATSHOWNAME NUMERIC(1) DEFAULT 1 NOT NULL;

ALTER TABLE CLOSEDCASH ADD COLUMN NOSALES SMALLINT DEFAULT 0 NOT NULL;

ALTER TABLE CUSTOMERS ADD COLUMN IMAGE BLOB;

ALTER TABLE PAYMENTS ADD COLUMN TENDERED DOUBLE PRECISION NOT NULL;
ALTER TABLE PAYMENTS ADD COLUMN CARDNAME VARCHAR2(256);
ALTER TABLE PAYMENTS ADD COLUMN NOTES VARCHAR2(256);
UPDATE PAYMENTS SET TENDERED = TOTAL WHERE TENDERED = 0;

ALTER TABLE PLACES ADD COLUMN CUSTOMER VARCHAR2(256);
ALTER TABLE PLACES ADD COLUMN WAITER VARCHAR2(256);
ALTER TABLE PLACES ADD COLUMN TICKETID VARCHAR2(256);
ALTER TABLE PLACES ADD COLUMN TABLEMOVED NUMERIC(1) DEFAULT 0 NOT NULL;

ALTER TABLE PRODUCTS ADD COLUMN ISVPRICE NUMERIC(1) DEFAULT 0 NOT NULL;
ALTER TABLE PRODUCTS ADD COLUMN ISVERPATRIB NUMERIC(1) DEFAULT 0 NOT NULL;
ALTER TABLE PRODUCTS ADD COLUMN TEXTTIP VARCHAR2(256) DEFAULT NULL;
ALTER TABLE PRODUCTS ADD COLUMN WARRANTY NUMERIC(1) DEFAULT 0 NOT NULL;

ALTER TABLE SHAREDTICKETS ADD COLUMN APPUSER VARCHAR2(256) DEFAULT NULL;
ALTER TABLE SHAREDTICKETS ADD COLUMN PICKUPID INTEGER DEFAULT 0 NOT NULL;

ALTER TABLE STOCKDIARY ADD COLUMN APPUSER VARCHAR2(256);

-- UPDATE App' version
UPDATE APPLICATIONS SET NAME = $APP_NAME{}, VERSION = $APP_VERSION{} WHERE ID = $APP_ID{};

-- final script
DELETE FROM SHAREDTICKETS;