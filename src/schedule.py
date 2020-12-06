'''
Processes data from Google and Apple
Author:  Tiago Tamagusko <tamagusko@gmail.com>
Version: 0.5 (2020-12-06)
License: CC-BY-NC-ND-4.0
'''
import pandas as pd


def drop_df_col(df, *columns_drop):
    '''drop dataframe columns '''
    df.drop(df.columns[[columns_drop]], axis=1, inplace=True)
    return df


def replace_df_col(df, old, new):
    '''replace dataframe columns
    in:  dataframe old columns and new columns
    out: dataframe with new columns
    '''
    df.columns = df.columns.str.replace(old, new)
    return df


def prepare_google_data():
    '''Prepare google data'''
    raw_google_data = (
        'https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv'
    )

    # adapted for big data using chuck
    data_iterator = pd.read_csv(
        raw_google_data,
        index_col='date',
        parse_dates=[4],
        low_memory=False,
        chunksize=10000,
        usecols=[
            'country_region',
            'sub_region_1',
            'date',
            'retail_and_recreation_percent_change_from_baseline',
            'grocery_and_pharmacy_percent_change_from_baseline',
            'parks_percent_change_from_baseline',
            'transit_stations_percent_change_from_baseline',
            'workplaces_percent_change_from_baseline',
            'residential_percent_change_from_baseline',
        ],
        infer_datetime_format=True,
    )

    chunk_list = []

    # Each chunk is in dataframe format
    for data_chunk in data_iterator:
        data_chunk = data_chunk[data_chunk['country_region']
                                == 'Portugal'].fillna('-1')
        # filter by "-1" value
        data_chunk = data_chunk[data_chunk['sub_region_1'] == '-1']
        chunk_list.append(data_chunk)
    # concat all chucks
    df = pd.concat(chunk_list)
    replace_df_col(df, r'_percent_change_from_baseline', '')
    replace_df_col(df, r'_', ' ')
    df = drop_df_col(df, 0, 1)
    df.to_csv('data/google_data_processed.csv')


prepare_google_data()
