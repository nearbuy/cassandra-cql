require File.expand_path('spec_helper.rb', File.dirname(__FILE__))
include CassandraCQL

describe "Database" do
  before do
    @connection = setup_cassandra_connection
  end

  describe "schema" do
    it "should cache schema" do
      @connection.connection.should_receive(:describe_keyspace).exactly(1).times.and_call_original
      @connection.schema
      @connection.schema
    end

    it "empties cache on keyspace change" do
      @connection.connection.should_receive(:describe_keyspace).exactly(2).times.and_call_original

      @connection.schema
      @connection.keyspace = "CassandraCQLTestKeyspace"
      @connection.schema
    end

    it "allows cache reset" do
      @connection.connection.should_receive(:describe_keyspace).exactly(2).times.and_call_original
      @connection.schema
      @connection.reset_cached_schema!
      @connection.schema
    end
  end

  describe "reset!" do
    it "should create a new connection" do
      @connection.should_receive(:connect!)
      @connection.reset!
    end
  end
end
