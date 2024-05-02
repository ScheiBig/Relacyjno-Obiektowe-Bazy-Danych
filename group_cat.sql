drop function group_cat;
drop type group_cat_agg_type;
drop type with_separator;

create or replace type with_separator as object (
	str varchar2(1023),
	separator varchar2(31)
);
/
show errors

create or replace type group_cat_agg_type as object (
	result_str varchar(32767),
	separator varchar(31),

	static function ODCIAggregateInitialize(
		result_self in out group_cat_agg_type
	) return number,

	member function ODCIAggregateIterate(
		self in out group_cat_agg_type
		, value with_separator
	) return number,

	member function ODCIAggregateMerge(
		self in out group_cat_agg_type
		, other in group_cat_agg_type
	) return number,

	member function ODCIAggregateTerminate(
		self in group_cat_agg_type
		, return_value out varchar2
		, flags in number
	) return number
);
/
show errors

create or replace type body group_cat_agg_type 
is
	static function ODCIAggregateInitialize(
		result_self in out group_cat_agg_type
	) return number
	is begin
		result_self := group_cat_agg_type( '', null );
		return ODCIConst.Success;
	end;

	member function ODCIAggregateIterate(
		self in out group_cat_agg_type
		, value with_separator
	) return number
	is begin
		if self.separator is null
		then
			if value.separator is null
			then
				return ODCIConst.Error;
			end if;
			self.separator := value.separator;
		end if;

		self.result_str := self.result_str || self.separator || value.str;
		return ODCIConst.Success;
	end;

	member function ODCIAggregateMerge(
		self in out group_cat_agg_type
		, other in group_cat_agg_type
	) return number
	is begin
		self.result_str := self.result_str || other.result_str;
		return ODCIConst.Success;
	end;

	member function ODCIAggregateTerminate(
		self in group_cat_agg_type
		, return_value out varchar2
		, flags in number
	) return number
	is begin
		return_value := substr( self.result_str, length( self.separator ) + 1 );
		return ODCIConst.Success;
	end;
end;
/
show errors

create or replace function group_cat(
	input_value with_separator
) return varchar2
parallel_enable aggregate
using group_cat_agg_type;
/
show errors
