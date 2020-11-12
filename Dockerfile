FROM php:7.4-fpm

ADD php-extensions.sh /root/php-extensions.sh
ADD moodle-extension.php /root/moodle-extension.php

RUN /root/php-extensions.sh

# Fix the original permissions of /tmp, the PHP default upload tmp dir.
RUN chmod 777 /tmp && chmod +t /tmp

RUN mkdir /var/www/moodledata && chown www-data /var/www/moodledata && \
    mkdir /var/www/phpunitdata && chown www-data /var/www/phpunitdata && \
    mkdir /var/www/behatdata && chown www-data /var/www/behatdata && \
    mkdir /var/www/behatfaildumps && chown www-data /var/www/behatfaildumps

COPY /src /var/www/html
ADD /es_39.tar.gz /var/www/html/lang
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php/php.ini

RUN /root/moodle-extension.php https://moodle.org/plugins/download.php/22788/gradeexport_checklist_moodle310_2020101700.zip /var/www/html/grade/export/ \
  && /root/moodle-extension.php https://moodle.org/plugins/download.php/22787/mod_checklist_moodle310_2020110700.zip /var/www/html/mod/ \
  && /root/moodle-extension.php https://moodle.org/plugins/download.php/21827/filter_poodll_moodle310_2020062400.zip /var/www/html/mod/ \
  && /root/moodle-extension.php https://moodle.org/plugins/download.php/22837/assignfeedback_poodll_moodle310_2020111200.zip /var/www/html/mod/ \
  && /root/moodle-extension.php https://moodle.org/plugins/download.php/22807/local_feedbackviewer_moodle310_2020100701.zip /var/www/html/mod/ \

VOLUME /var/www/moodledata
