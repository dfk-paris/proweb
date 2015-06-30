class Proweb::Import

  def initialize(source, target)
    @source = source
    @target = target

    @options = {
      :per_page => 1000
    }
  end

  def run
    # @target.run "SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO'"

    transfer "tsprache", "languages", {
      'spracheid' => {:name => "id", :type => Integer, :options => {:primary_key => true}},
      "sprachebezeichnung" => {:name => "name"},
      "sprachekurz" => {:name => "short_name"}
    }

    transfer "tprojekt", "projects", {
      'projektid' => {:name => "id", :type => Integer, :options => {:primary_key => true}}
    }

    transfer "tprojektsprache", "project_translations", {
      'projektid' => {:name => "project_id", :type => Integer},
      'spracheid' => {:name => "language_id", :type => Integer},
      'projektname' => {:name => 'name'},
      'projektnamekurz' => {:name => 'short_name'},
      'projektbeschreibung' => {:name => 'description', :options => {:text => true}}
    }

    transfer 'tattribut', 'attributes', {
      'attributid' => {:name => "id", :type => Integer, :options => {:primary_key => true}},
      'attributartid' => {:name => "attribute_kind_id", :type => Integer}
    }

    transfer 'tattributsprache', 'attribute_translations', {
      'attributid' => {:name => 'attribute_id', :type => Integer},
      'spracheid' => {:name => 'language_id', :type => Integer},
      'attributbez' => {:name => 'name'},
      'attributinfo' => {:name => 'comment', :options => {:text => true}}
    }

    transfer 'tattributart', 'attribute_kinds', {
      'attributartid' => {:name => "id", :type => Integer, :options => {:primary_key => true}},
      'attributartklasseid' => {:name => 'attribute_class_id', :type => Integer}
    }

    transfer 'tattributartsprache', 'attribute_kind_translations', {
      'attributartid' => {:name => 'attribute_kind_id', :type => Integer},
      'spracheid' => {:name => 'language_id', :type => Integer},
      'attributartbez' => {:name => 'name'},
      'attributartinfo' => {:name => 'comment', :options => {:text => true}}
    }

    transfer "tobjekt", "objects", {
      "objektid" => {:name => "id", :type => Integer, :options => {:primary_key => true}},
      'projektid' => {:name => 'project_id', :type => Integer},
      'zeitschriftnameid' => {:name => 'journal_id', :type => Integer},
      'bandid' => {:name => 'volume_id', :type => Integer},
      'herausgeberid' => {:name => 'issuer_id', :type => Integer},
      "datum_anfang" => {:name => "from_date"},
      "datum_ende" => {:name => "to_date"},
      "erscheinungsdatum" => {:name => "issued_on"},
      "datumtag_nodisplay" => {:name => "ed_ignore_day", :type => TrueClass},
      "datummonat_nodisplay" => {:name => "ed_ignore_month", :type => TrueClass},
      'erstelltam' => {:name => 'created_on'},
      'erstelltdurch_benutzerkurz' => {:name => 'created_by'},
      'letzteaenderung_am' => {:name => 'updated_on'},
      'letzteaenderung_benutzerkurz' => {:name => 'updated_by'},
      'kategorieid' => {:name => "category_id", :type => Integer},
      'objekttypid' => {:name => "object_type_id", :type => Integer},
      'bemerkung' => {:name => 'comment', :options => {:text => true}}
    }

    transfer 'tprojektattribut', 'projects_attributes', {
      'projektid' => {:name => 'project_id', :type => Integer},
      'attributid' => {:name => 'attribute_id', :type => Integer}
    }

    transfer 'tobjektsprache', 'object_translations', {
      'os_objektid' => {:name => 'object_id', :type => Integer},
      'os_spracheid' => {:name => 'language_id', :type => Integer},
      'os_kurztitel' => {:name => 'short_title'},
      'os_titel' => {:name => 'title'},
      'os_inhalt' => {:name => 'content', :options => {:text => true}},
      'os_abstract' => {:name => 'abstract', :options => {:text => true}},
      'os_interpretation' => {:name => 'interpretation', :options => {:text => true}}
    }

    transfer 'tobjektattribut', 'object_attributes', {
      'objektid' => {:name => 'object_id', :type => Integer},
      'attributid' => {:name => 'attribute_id', :type => Integer},
      'attributartid_gesucht' => {:name => 'kind_id', :type => Integer}
    }

    transfer 'tperson', 'people', {
      'personid' => {:name => 'id', :type => Integer, :options => {:primary_key => true}},
      "personsuchname" => {:name => "display_name"},
      "anrede" => {:name => "title"},
      "vorname" => {:name => "first_name"},
      "nachname" => {:name => "last_name"},
      "email" => {:name => "email"},
      "namensvarianten" => {:name => "variants"}
    }

    transfer 'tobjektperson', 'objects_people', {
      'personid' => {:name => 'person_id', :type => Integer},
      'objektid' => {:name => 'object_id', :type => Integer},
      'personentypid' => {:name => 'kind_id', :type => Integer}
    }

  end
  

  protected

    def transfer(source_table, target_table, directives = {})
      @target.drop_table(target_table) if @target.table_exists?(target_table)

      target_columns = []

      @target.create_table target_table do
        directives.each do |source_column_name, directive|
          name = (directive[:name] || source_column_name).to_sym
          type = directive[:type] || String
          options = directive[:options] || {}
          target_columns << name.to_sym
          column name, type, options
        end
      end

      values = []

      batch_read source_table do |source_record|
        target_record = []

        directives.each do |source_column_name, directive|
          target_record << source_record[source_column_name.to_sym]
        end

        values << target_record

        if values.size >= @options[:per_page]
          @target[target_table.to_sym].import(target_columns, values)
          values = []
        end
      end

      @target[target_table.to_sym].import(target_columns, values)
    end

    def batch_read(source_table)
      puts "processing table '#{source_table}'"
      total = @source[source_table.to_sym].count

      page = 0
      while (records = batch_from(source_table, page)).size > 0
        records.each do |record|
          yield record
        end

        page += 1
        puts "#{page}/#{total / @options[:per_page] + 1} done"
      end
    end

    def batch_from(source_table, page = 0)
      order_by = @source.schema(source_table).first.first
      @source[source_table.to_sym].order(order_by).
        limit(@options[:per_page], page * @options[:per_page]).all
    end
    

end
